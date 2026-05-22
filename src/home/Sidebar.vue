<script setup lang="ts">
import AddChannelButton from './AddChannelButton.vue';
import HomeSidebarChannels from './HomeSidebarChannels.vue';
import HomeSidebarUsers from './HomeSidebarUsers.vue';

</script>

<template>
    <aside
        class="relative hidden w-80 shrink-0 border-e border-white/10 bg-slate-900/55 px-5 py-6 lg:flex lg:flex-col lg:backdrop-blur-2xl">
        <div
            class="rounded-3xl border border-white/10 bg-gradient-to-br from-white/10 to-white/[0.04] px-5 py-5 shadow-[0_30px_60px_-40px_rgba(2,6,23,0.95)]">
            <div class="flex items-start justify-between gap-4">
                <div>
                    <p class="text-xs font-bold uppercase tracking-[0.3em] text-emerald-200/80">Workspace</p>
                    <h1 class="mt-2 text-2xl font-black tracking-tight text-white">Finch Chat</h1>
                    <p class="mt-1 text-sm text-slate-400">Fast team communication with our slate + emerald palette.
                    </p>
                </div>
                <AddChannelButton />
            </div>

            <div class="mt-5 rounded-2xl border border-white/10 bg-slate-950/35 px-4 py-3 text-sm text-slate-300">
                <div class="flex items-center gap-3">
                    <i class="fa-solid fa-magnifying-glass text-emerald-200/80"></i>
                    <span>Search messages</span>
                </div>
            </div>

            <div class="mt-6 space-y-6">
                <div>
                    <p class="mb-3 text-xs font-bold uppercase tracking-[0.28em] text-slate-500">Channels</p>
                    <div class="text-sm" id="chat-sidebar-channels">
                        <HomeSidebarChannels />
                    </div>
                </div>

                <div>
                    <p class="mb-3 text-xs font-bold uppercase tracking-[0.28em] text-slate-500">Direct Messages</p>
                    <div class="space-y-2 text-sm">
                        <HomeSidebarUsers />
                    </div>
                </div>
            </div>
        </div>
    </aside>
</template>