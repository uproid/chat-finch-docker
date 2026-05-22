<script setup>
import { ref } from 'vue';
import { finchSocket } from './socket_client';

const open = ref(false);
const slug = ref('');

function submit() {
    const value = slug.value.trim();
    if (!value) return;
    finchSocket('new_channel', { slug: value });
    slug.value = '';
    open.value = false;
}
</script>

<template>
    <button
        @click="open = true"
        class="flex h-[25px] w-[50px] items-center justify-center rounded-2xl bg-emerald-400 text-slate-950 shadow-[0_18px_35px_-20px_rgba(16,185,129,0.95)] transition hover:scale-[1.03]">
        <i class="fa-solid fa-plus"></i>
    </button>

    <!-- Dialog overlay -->
    <Teleport to="body">
        <div v-if="open" class="fixed inset-0 z-50 flex items-center justify-center">
            <!-- Backdrop -->
            <div class="absolute inset-0 bg-slate-950/70 backdrop-blur-sm" @click="open = false"></div>

            <!-- Modal -->
            <div class="relative w-full max-w-sm rounded-2xl border border-white/10 bg-slate-900 p-6 shadow-2xl">
                <h2 class="mb-4 text-base font-semibold text-white">New Channel</h2>

                <label class="mb-1 block text-xs font-medium text-slate-400">Slug</label>
                <input
                    v-model="slug"
                    @keydown.enter="submit"
                    type="text"
                    placeholder="e.g. general"
                    class="w-full rounded-xl border border-white/10 bg-white/5 px-4 py-2.5 text-sm text-white placeholder-slate-500 outline-none focus:border-emerald-400/60 focus:ring-1 focus:ring-emerald-400/40"
                />

                <div class="mt-5 flex justify-end gap-2">
                    <button
                        @click="open = false"
                        class="rounded-xl px-4 py-2 text-sm text-slate-400 transition hover:text-white">
                        Cancel
                    </button>
                    <button
                        @click="submit"
                        class="rounded-xl bg-emerald-400 px-5 py-2 text-sm font-semibold text-slate-950 shadow-[0_8px_20px_-8px_rgba(16,185,129,0.8)] transition hover:scale-[1.03]">
                        Create
                    </button>
                </div>
            </div>
        </div>
    </Teleport>
</template>