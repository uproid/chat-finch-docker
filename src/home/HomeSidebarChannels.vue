<script setup>
import { ref } from 'vue';
import { RouterLink } from 'vue-router';
import { finchSocket } from './socket_client';

const emit = defineEmits(['link-click']);
const channels = ref([]);

finchSocket('channels', {}, function (payload) {
    channels.value = payload.data.items;
});
</script>

<template>
    <div class="home-sidebar-channels">
        <ul class="rounded-lg">
            <li v-for="channel in channels" :key="channel.id">
                <RouterLink :to="`/channel/${channel.slug}/${channel.id}`"
                    class="flex items-center gap-3 rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white"
                    active-class="bg-white/10 text-white"
                    @click="emit('link-click')">
                    <span class="fa fa-hashtag text-emerald-400"></span>
                    {{ channel.slug }}
                </RouterLink>
            </li>
        </ul>
    </div>
</template>