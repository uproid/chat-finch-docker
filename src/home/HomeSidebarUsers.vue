<script setup>
import { ref } from 'vue';
import { RouterLink } from 'vue-router';
import { addSocketEvent, initWebSocket } from './socket_client';
import { myID } from '../utility/helper';

const emit = defineEmits(['link-click']);
const users = ref([]);
const unreadCounts = ref({});

// Load user list
addSocketEvent('users', (payload) => {
    users.value = payload.data.items;
});
initWebSocket({ path: 'users', data: {} });

// Subscribe to unread-count updates (initial load + pushed updates)
addSocketEvent('unread_counts', (payload) => {
    unreadCounts.value = payload.data.counts ?? {};
});
initWebSocket({ path: 'unread_counts', data: {} });
</script>

<template>
    <div v-for="user in users" :key="user.id">
        <RouterLink v-if="myID() !== user.id" :to="`/user/${user.username}/${user.id}`"
            class="flex items-center gap-3 rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white"
            active-class="bg-white/10 text-white"
            @click="emit('link-click')">
            <span class="h-2.5 w-2.5 shrink-0 rounded-full bg-emerald-400"></span>
            <span class="flex-1 truncate">{{ user.username }}</span>
            <span v-if="unreadCounts[user.id] > 0"
                class="flex h-5 min-w-5 items-center justify-center rounded-full bg-sky-400 px-1.5 text-xs font-bold text-slate-950">
                {{ unreadCounts[user.id] > 99 ? '99+' : unreadCounts[user.id] }}
            </span>
        </RouterLink>
    </div>
</template>