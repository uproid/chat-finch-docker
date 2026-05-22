<script setup>
import { ref, watch, nextTick } from 'vue';
import { useRoute } from 'vue-router';
import { addSocketEvent, finchSocket, initWebSocket } from '../../home/socket_client';
import { myID } from '../../utility/helper';
import Message from '../../components/Message.vue';

const route = useRoute();
const draft = ref('');
const messages = ref([]);
const profile = ref(null);
const scrollEl = ref(null);
const myId = ref(myID());

function scrollToBottom() {
  nextTick(() => {
    if (scrollEl.value) scrollEl.value.scrollTop = scrollEl.value.scrollHeight;
  });
}
function loadUser(id) {
  messages.value = [];
  profile.value = null;
  finchSocket('users_messages', { users: [id, myID()] }, (payload) => {
    messages.value = payload.data.items ?? [];
    scrollToBottom();
  });
}

loadUser(route.params.id);
watch(() => route.params.id, (id) => loadUser(id));
addSocketEvent('new_message_from_user', (socket, payload) => {
  loadUser(route.params.id);
});

function sendMessage() {
  const text = draft.value.trim();
  if (!text) return;
  initWebSocket({
    path: 'send_message_to_user',
    data: { to: route.params.id, message: text },
  });


  draft.value = '';
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
        <input v-model="draft" @keydown.enter="sendMessage" :placeholder="`Message ${route.params.id}…`"
          class="min-w-0 flex-1 bg-transparent text-sm text-slate-200 placeholder-slate-500 outline-none" />
        <button @click="sendMessage"
          class="rounded-xl bg-sky-400 px-4 py-2 text-xs font-bold text-slate-950 transition hover:bg-sky-300">
          Send
        </button>
      </div>
    </div>

  </div>
</template>
