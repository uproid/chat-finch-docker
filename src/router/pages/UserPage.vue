<script setup>
import { ref, watch, nextTick, onMounted, onUnmounted } from 'vue';
import { useRoute } from 'vue-router';
import { useInfiniteScroll } from '@vueuse/core';
import { addSocketEvent, initWebSocket } from '../../home/socket_client';
import { myID } from '../../utility/helper';
import Message from '../../components/Message.vue';

const route = useRoute();
const draft = ref('');
const messages = ref([]);
const scrollEl = ref(null);

// Pagination state
const currentUsers = ref([]);
const nextPage = ref(2);
const hasMore = ref(true);

// Holds the resolve() of the Promise useInfiniteScroll is waiting on
let resolvePendingLoad = null;

// ── Scroll helpers ────────────────────────────────────────────────────────────

function scrollToBottom() {
  nextTick(() => {
    requestAnimationFrame(() => {
      if (scrollEl.value) {
        scrollEl.value.scrollTop = scrollEl.value.scrollHeight;
      }
    });
  });
}

function preserveScrollAfterPrepend(prevScrollHeight) {
  nextTick(() => {
    if (scrollEl.value) {
      scrollEl.value.scrollTop = scrollEl.value.scrollHeight - prevScrollHeight;
    }
  });
}

// ── Conversation identity helpers ─────────────────────────────────────────────
// A DM conversation is identified by the sorted pair of participant IDs.

function conversationKey(users) {
  return users.map(String).sort().join(',');
}

function currentKey() {
  return conversationKey([myID(), route.params.id]);
}

// ── Central users_messages handler ───────────────────────────────────────────
// Registered once; handles both real-time updates (page 1) and pagination (page N).

function handleUsersMessages(payload) {
  const data = payload.data ?? {};
  const items = data.items ?? [];
  const page = data.page ?? 1;
  const users = data.users ?? [];

  // Discard responses that belong to a different conversation
  if (conversationKey(users) !== currentKey()) return;

  if (page === 1) {
    // Initial load or real-time update (new message sent) — replace and reset.
    // Server returns newest-first (DESC); reverse so oldest is at top, newest at bottom.
    messages.value = items.slice().reverse();
    hasMore.value = items.length > 0;
    nextPage.value = 2;
    scrollToBottom();

    // Conversation is open — immediately mark incoming messages as read
    initWebSocket({
      path: 'mark_read',
      data: { user_id: String(route.params.id) },
    });

    // Unblock any in-progress pagination
    if (resolvePendingLoad) {
      resolvePendingLoad();
      resolvePendingLoad = null;
    }
  } else {
    // Paginated response: prepend older messages while keeping scroll position
    if (items.length === 0) {
      hasMore.value = false;
    } else {
      const prevScrollHeight = scrollEl.value?.scrollHeight ?? 0;
      messages.value = [...items.slice().reverse(), ...messages.value];
      preserveScrollAfterPrepend(prevScrollHeight);
      nextPage.value = page + 1;
    }

    if (resolvePendingLoad) {
      resolvePendingLoad();
      resolvePendingLoad = null;
    }
  }
}

let removeUsersMessagesHandler = null;

onMounted(() => {
  removeUsersMessagesHandler = addSocketEvent('users_messages', handleUsersMessages);
});

onUnmounted(() => {
  if (removeUsersMessagesHandler) {
    removeUsersMessagesHandler();
    removeUsersMessagesHandler = null;
  }
  if (resolvePendingLoad) {
    resolvePendingLoad();
    resolvePendingLoad = null;
  }
});

// ── Conversation loading ──────────────────────────────────────────────────────

function loadUser(id) {
  if (resolvePendingLoad) {
    resolvePendingLoad();
    resolvePendingLoad = null;
  }

  currentUsers.value = [myID(), id];
  messages.value = [];
  nextPage.value = 2;
  hasMore.value = true;

  initWebSocket({
    path: 'users_messages',
    data: { users: [id, myID()], page: 1 },
  });

  // Mark messages from this user as read; server will push updated unread_counts
  initWebSocket({
    path: 'mark_read',
    data: { user_id: id },
  });
}

loadUser(route.params.id);
watch(() => route.params.id, (id) => loadUser(id));

// ── Infinite scroll (reverse — triggers when scrolled near the top) ───────────

const { isLoading: isPaginating } = useInfiniteScroll(
  scrollEl,
  () =>
    new Promise((resolve) => {
      if (!hasMore.value) {
        resolve();
        return;
      }
      resolvePendingLoad = resolve;
      initWebSocket({
        path: 'users_messages',
        data: { users: currentUsers.value, page: nextPage.value },
      });
    }),
  {
    direction: 'top',
    distance: 80,
    canLoadMore: () => hasMore.value,
  },
);

// ── Message composer ─────────────────────────────────────────────────────────

function sendMessage() {
  const text = draft.value.trim();
  if (!text) return;
  initWebSocket({
    path: 'send_message_to_user',
    data: { to: route.params.id, message: text },
  });
  draft.value = '';
  // Pagination reset is handled automatically when the server broadcasts
  // users_messages page=1 to both participants.
}
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col overflow-hidden">

    <!-- Header -->
    <header class="border-b border-white/10 px-4 py-4 sm:px-6 lg:px-8">
      <div class="flex items-center gap-3">
        <div class="flex h-10 w-10 items-center justify-center rounded-2xl bg-sky-300 font-bold text-slate-950">
          {{ route.params.username.slice(0, 2).toUpperCase() }}
        </div>
        <div>
          <h2 class="text-2xl font-black tracking-tight text-white">{{ route.params.username }}</h2>
          <p v-if="profile?.email" class="text-xs text-slate-400">{{ profile.email }}</p>
        </div>
        <span
          class="rounded-full border border-sky-300/20 bg-sky-400/10 px-3 py-1 text-xs font-bold uppercase tracking-[0.2em] text-sky-100">
          DM
        </span>
      </div>
    </header>

    <!-- Messages -->
    <div
      ref="scrollEl"
      class="min-h-0 flex-1 overflow-y-auto px-4 py-5 sm:px-6 lg:px-8 scrollbar-thin scrollbar-track-slate-900/20 scrollbar-thumb-slate-700/80 hover:scrollbar-thumb-slate-600">

      <!-- End-of-history indicator -->
      <div v-if="!hasMore && messages.length > 0"
        class="mb-4 flex items-center gap-3 text-xs text-slate-500">
        <div class="h-px flex-1 bg-white/5"></div>
        <span>Beginning of conversation</span>
        <div class="h-px flex-1 bg-white/5"></div>
      </div>

      <!-- Loading older messages spinner -->
      <div v-if="isPaginating && messages.length > 0"
        class="mb-4 flex justify-center">
        <span class="fa fa-circle-notch fa-spin text-sky-400/60 text-sm"></span>
      </div>

      <div v-if="messages.length === 0" class="flex h-full items-center justify-center text-slate-500 text-sm">
        No messages yet — start the conversation.
      </div>
      <div class="flex flex-col gap-4">
        <Message v-for="msg in messages" :key="msg.id" :message="msg" />
        <!-- article v-for="msg in messages" :key="msg.id"
          :class="['flex gap-4 rounded-3xl border p-5 max-w-[75%]', msg.user_id === myId ? 'self-end flex-row-reverse border-sky-400/20 bg-sky-400/[0.07]' : 'self-start border-emerald-400/20 bg-emerald-400/[0.07]']">
          <div
            :class="['flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl font-black text-slate-950', msg.user_id === myId ? 'bg-sky-300' : 'bg-emerald-300']">
            {{ (msg.user_username ?? 'U').slice(0, 2).toUpperCase() }}
          </div>
          <div class="min-w-0 flex-1">
            <div class="flex flex-wrap items-center gap-x-3 gap-y-1">
              <h3 class="text-base font-extrabold text-white">{{ msg.user_username }}</h3>
              <span class="text-xs uppercase tracking-[0.2em] text-slate-500">{{ msg.created_at }}</span>
            </div>
            <p class="mt-2 text-sm leading-7 text-slate-300">{{ msg.message }}</p>
          </div>
        </!-->
      </div>
    </div>

    <!-- Composer -->
    <div class="border-t border-white/10 px-4 py-4 sm:px-6 lg:px-8">
      <div class="flex items-center gap-3 rounded-2xl border border-white/10 bg-white/5 px-4 py-3">
        <textarea v-model="draft"
            @keydown.enter.exact.prevent="sendMessage"
            :placeholder="`Message ${route.params.username}\u2026`"
            rows="1"
            @input="$event.target.style.height = 'auto'; $event.target.style.height = $event.target.scrollHeight + 'px'"
            class="min-w-0 flex-1 resize-none overflow-hidden bg-transparent text-sm text-slate-200 placeholder-slate-500 outline-none" />
        <button @click="sendMessage"
          class="rounded-xl bg-sky-400 px-4 py-2 text-xs font-bold text-slate-950 transition hover:bg-sky-300">
          Send
        </button>
      </div>
    </div>

  </div>
</template>
