<script setup>
import { ref } from 'vue';
import { myID } from '../utility/helper';

const props = defineProps({
  message: Object,
});

</script>

<template>
    <article
        :class="['flex gap-4 rounded-3xl border p-5 max-w-[75%]', message.user_id === myID() ? 'self-end flex-row-reverse border-sky-400/20 bg-sky-400/[0.07]' : 'self-start border-emerald-400/20 bg-emerald-400/[0.07]']">
        <div
            :class="['flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl font-black text-slate-950', message.user_id === myID() ? 'bg-sky-300' : 'bg-emerald-300']">
            {{ (message.user_username ?? 'U').slice(0, 2).toUpperCase() }}
        </div>
        <div class="min-w-0 flex-1">
            <div class="flex flex-wrap items-center gap-x-3 gap-y-1">
                <h3 class="text-base font-extrabold text-white">{{ message.user_username }}</h3>
                <span class="text-xs uppercase tracking-[0.2em] text-slate-500">{{ message.created_at }}</span>
            </div>
            <p class="mt-2 text-sm leading-7 text-slate-300 whitespace-pre-wrap break-words">{{ message.message }}</p>
        </div>
    </article>
</template>