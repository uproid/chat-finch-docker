<script setup lang="ts">
import AddChannelButton from './AddChannelButton.vue';
import HomeSidebarChannels from './HomeSidebarChannels.vue';
import HomeSidebarUsers from './HomeSidebarUsers.vue';

const props = defineProps<{ open?: boolean }>();
const emit = defineEmits(['close']);
</script>

<template>
    <!-- Mobile backdrop -->
    <Transition name="fade">
        <div
            v-if="open"
            class="fixed inset-0 z-40 bg-slate-950/70 backdrop-blur-sm lg:hidden"
            @click="emit('close')"
        />
    </Transition>

    <!-- Sidebar panel -->
    <aside
        :class="[
            'fixed inset-y-0 start-0 z-50 flex w-80 shrink-0 flex-col border-e border-white/10 bg-slate-900/95 px-5 py-6 backdrop-blur-2xl transition-transform duration-300',
            'lg:static lg:translate-x-0',
            open ? 'translate-x-0' : '-translate-x-full'
        ]">

        <!-- Mobile close button -->
        <button
            class="absolute end-4 top-4 flex h-9 w-9 items-center justify-center rounded-xl bg-white/10 text-white/70 transition hover:bg-white/20 lg:hidden"
            @click="emit('close')"
        >
            <i class="fa-solid fa-xmark"></i>
        </button>

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
                        <HomeSidebarChannels @link-click="emit('close')" />
                    </div>
                </div>

                <div>
                    <p class="mb-3 text-xs font-bold uppercase tracking-[0.28em] text-slate-500">Direct Messages</p>
                    <div class="space-y-2 text-sm">
                        <HomeSidebarUsers @link-click="emit('close')" />
                    </div>
                </div>
            </div>
        </div>
    </aside>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.3s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
</style>