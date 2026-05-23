<script setup>
import { ref } from 'vue';
import { RouterLink } from 'vue-router';
import { finchSocket } from './socket_client';
import { myID } from '../utility/helper';

const emit = defineEmits(['link-click']);
var users = ref([]);
finchSocket('users', {}, function (payload) {
    users.value = payload.data.items;
});

</script>

<template>
    <div v-for="user in users" :key="user.id">
        <RouterLink v-if="myID() !== user.id" :to="`/user/${user.username}/${user.id}`"
            class="flex items-center gap-3 rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white"
            active-class="bg-white/10 text-white"
            @click="emit('link-click')">
            <span class="h-2.5 w-2.5 rounded-full bg-emerald-400"></span>
            {{ user.username }}
        </RouterLink>
    </div>
</template>