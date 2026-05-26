<script setup>
import { ref, watch, nextTick, onMounted, onUnmounted } from 'vue';
import { useRoute } from 'vue-router';
import { useInfiniteScroll } from '@vueuse/core';
import { addSocketEvent, initWebSocket } from '../../home/socket_client';
import Message from '../../components/Message.vue';

const route = useRoute();
const draft = ref('');
const messages = ref([]);
const messagesEl = ref(null);

// Pagination state
const currentChannelId = ref(null);
const nextPage = ref(2);
const hasMore = ref(true);

// Holds the resolve() of the Promise useInfiniteScroll is waiting on
let resolvePendingLoad = null;

// ── Scroll helpers ────────────────────────────────────────────────────────────

function scrollToBottom() {
  nextTick(() => {
    requestAnimationFrame(() => {
      if (messagesEl.value) {
        messagesEl.value.scrollTop = messagesEl.value.scrollHeight;
      }
    });
  });
}

function preserveScrollAfterPrepend(prevScrollHeight) {
  nextTick(() => {
    if (messagesEl.value) {
      messagesEl.value.scrollTop =
        messagesEl.value.scrollHeight - prevScrollHeight;
    }
  });
}

// ── Central channel_chats handler ────────────────────────────────────────────
// Registered once; handles both real-time updates (page 1) and pagination (page N).

function handleChannelChats(payload) {
  const data = payload.data ?? {};
  const items = data.items ?? [];
  const page = data.page ?? 1;
  const channelId = String(data.channel_id ?? '');

  // Discard responses that belong to a different channel
  if (channelId !== String(currentChannelId.value)) return;

  if (page === 1) {
    // Initial load or real-time update triggered by a new message —
    // replace the message list and reset pagination.
    // Server returns newest-first (DESC); reverse so oldest is at top, newest at bottom.
    messages.value = items.slice().reverse();
    hasMore.value = items.length > 0;
    nextPage.value = 2;
    scrollToBottom();

    // Unblock any in-progress pagination (send_chat resets everything)
    if (resolvePendingLoad) {
      resolvePendingLoad();
      resolvePendingLoad = null;
    }
  } else {
    // Paginated response: prepend older messages while keeping scroll position
    if (items.length === 0) {
      hasMore.value = false;
    } else {
      const prevScrollHeight = messagesEl.value?.scrollHeight ?? 0;
      // Reverse so the older batch is also in ascending order before prepending.
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

let removeChannelChatsHandler = null;

onMounted(() => {
  removeChannelChatsHandler = addSocketEvent('channel_chats', handleChannelChats);
});

onUnmounted(() => {
  if (removeChannelChatsHandler) {
    removeChannelChatsHandler();
    removeChannelChatsHandler = null;
  }
  // Unblock any dangling promise to avoid memory leaks
  if (resolvePendingLoad) {
    resolvePendingLoad();
    resolvePendingLoad = null;
  }
});

// ── Channel loading ───────────────────────────────────────────────────────────

function loadChannel(id) {
  // Unblock any in-flight pagination for the previous channel
  if (resolvePendingLoad) {
    resolvePendingLoad();
    resolvePendingLoad = null;
  }

  currentChannelId.value = id;
  messages.value = [];
  nextPage.value = 2;
  hasMore.value = true;

  initWebSocket({
    path: 'channel_chats',
    data: { channel_id: id, page: 1 },
  });
}

loadChannel(route.params.id);
watch(() => route.params.id, (id) => loadChannel(id));

// ── Infinite scroll (reverse — triggers when scrolled near the top) ───────────

const { isLoading: isPaginating } = useInfiniteScroll(
  messagesEl,
  () =>
    new Promise((resolve) => {
      if (!hasMore.value) {
        resolve();
        return;
      }
      resolvePendingLoad = resolve;
      initWebSocket({
        path: 'channel_chats',
        data: { channel_id: currentChannelId.value, page: nextPage.value },
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
    path: 'send_chat',
    data: {
      channel_id: route.params.id,
      message: text,
      user_id: request.user.id,
    },
  });
  draft.value = '';
  // Pagination reset is handled automatically when the server broadcasts
  // channel_chats page=1 in response to send_chat.
}
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col overflow-hidden">

    <!-- Header -->
    <header class="border-b border-white/10 px-4 py-4 sm:px-6 lg:px-8">
      <div class="flex items-center gap-3">
        <span class="fa fa-hashtag text-emerald-400 text-lg"></span>
        <h2 class="text-2xl font-black tracking-tight text-white">{{ route.params.slug }}</h2>
        <span
          class="rounded-full border border-emerald-300/20 bg-emerald-400/10 px-3 py-1 text-xs font-bold uppercase tracking-[0.2em] text-emerald-100">
          Live
        </span>
      </div>
    </header>

    <!-- Messages -->
    <div ref="messagesEl"
      class="min-h-0 flex-1 overflow-y-auto px-4 py-5 sm:px-6 lg:px-8 scrollbar-thin scrollbar-track-slate-900/20 scrollbar-thumb-slate-700/80 hover:scrollbar-thumb-slate-600">

      <!-- End-of-history indicator -->
      <div v-if="!hasMore && messages.length > 0"
        class="mb-4 flex items-center gap-3 text-xs text-slate-500">
        <div class="h-px flex-1 bg-white/5"></div>
        <span>Beginning of channel history</span>
        <div class="h-px flex-1 bg-white/5"></div>
      </div>

      <!-- Loading older messages spinner -->
      <div v-if="isPaginating && messages.length > 0"
        class="mb-4 flex justify-center">
        <span class="fa fa-circle-notch fa-spin text-emerald-400/60 text-sm"></span>
      </div>

      <div v-if="messages.length === 0" class="flex h-full items-center justify-center text-slate-500 text-sm">
        No messages yet — be the first to say something.
      </div>
      <div class="flex flex-col gap-4">
        <Message v-for="msg in messages" :key="msg.id" :message="msg" />
      </div>
    </div>

    <!-- Composer -->
    <div class="border-t border-white/10 px-4 py-4 sm:px-6 lg:px-8">
      <div class="flex items-center gap-3 rounded-2xl border border-white/10 bg-white/5 px-4 py-3">
        <input v-model="draft" @keydown.enter="sendMessage" :placeholder="`Message #${route.params.slug}…`"
          class="min-w-0 flex-1 bg-transparent text-sm text-slate-200 placeholder-slate-500 outline-none" />
        <button @click="sendMessage"
          class="rounded-xl bg-emerald-400 px-4 py-2 text-xs font-bold text-slate-950 transition hover:bg-emerald-300">
          Send
        </button>
      </div>
    </div>

  </div>
</template>
