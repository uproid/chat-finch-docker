<script setup>
import { ref, watch, nextTick } from 'vue';
import { useRoute } from 'vue-router';
import { finchSocket, initWebSocket } from '../../home/socket_client';
import Message from '../../components/Message.vue';

const route = useRoute();
const draft = ref('');
const messages = ref([]);
const messagesEl = ref(null);

function scrollToBottom() {
  nextTick(() => {
    if (messagesEl.value) messagesEl.value.scrollTop = messagesEl.value.scrollHeight;
  });
}

function loadChannel(id) {
  messages.value = [];
  finchSocket('channel_chats', { channel_id:id }, (payload) => {
    messages.value = payload.data.items ?? [];
    scrollToBottom();
  });
}

loadChannel(route.params.id);
watch(() => route.params.id, (id) => loadChannel(id));

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
  draft.value = '';    scrollToBottom();}
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
