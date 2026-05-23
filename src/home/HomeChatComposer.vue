<script setup>
import { ref } from 'vue';
import { RouterView } from 'vue-router';
import HomeSidebarChannels from './HomeSidebarChannels.vue';
import HomeSidebarUsers from './HomeSidebarUsers.vue';
import Sidebar from './Sidebar.vue';

const sidebarOpen = ref(false);
</script>

<template>
  <div
    class="relative flex h-screen w-screen overflow-hidden bg-[radial-gradient(circle_at_top_left,_rgba(16,185,129,0.2),_transparent_22%),radial-gradient(circle_at_bottom_right,_rgba(56,189,248,0.12),_transparent_24%),linear-gradient(135deg,_#020617,_#0f172a_40%,_#111827)]">
    <div
      class="pointer-events-none absolute inset-0 bg-[linear-gradient(180deg,_rgba(255,255,255,0.04),_transparent_30%,_transparent_70%,_rgba(15,23,42,0.25))]">
    </div>

    <!-- Icon sidebar — desktop only -->
    <aside
      class="relative hidden w-20 shrink-0 border-e border-white/10 bg-slate-950/80 px-4 py-5 xl:flex xl:flex-col xl:items-center xl:justify-between xl:backdrop-blur-xl">
      <div class="flex flex-col items-center gap-3">
        <div
          class="flex h-12 w-12 items-center justify-center rounded-2xl bg-emerald-400 text-base font-black text-slate-950 shadow-[0_18px_35px_-20px_rgba(16,185,129,0.95)]">
          FC
        </div>
        <div
          class="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/10 text-white/80 transition hover:bg-white/20">
          <i class="fa-solid fa-comments"></i>
        </div>
        <div
          class="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/5 text-white/60 transition hover:bg-white/10">
          <i class="fa-solid fa-bolt"></i>
        </div>
        <div
          class="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/5 text-white/60 transition hover:bg-white/10">
          <i class="fa-solid fa-calendar-days"></i>
        </div>
      </div>

      <div class="flex flex-col items-center gap-3">
        <a href="/logout"
          class="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/5 text-white/60 transition hover:bg-white/10">
          <i class="fa-solid fa-gear"></i>
        </a>
        <div
          class="flex h-11 w-11 items-center justify-center rounded-2xl border border-emerald-300/30 bg-emerald-400/10 text-sm font-bold text-emerald-100">
          FZ
        </div>
      </div>
    </aside>

    <Sidebar :open="sidebarOpen" @close="sidebarOpen = false" />

    <main
      class="relative flex min-w-0 flex-1 flex-col overflow-hidden rounded-none pb-16 lg:border-s lg:border-white/10 lg:bg-white/[0.04] lg:pb-0 lg:backdrop-blur-2xl">

      <!-- Mobile top bar -->
      <header
        class="flex h-14 shrink-0 items-center gap-3 border-b border-white/10 bg-slate-950/80 px-4 backdrop-blur-xl lg:hidden">
        <button
          @click="sidebarOpen = true"
          class="flex h-9 w-9 items-center justify-center rounded-xl bg-white/10 text-white/80 transition hover:bg-white/20">
          <i class="fa-solid fa-bars"></i>
        </button>
        <span class="text-lg font-black tracking-tight text-white">Finch Chat</span>
      </header>

      <RouterView />
    </main>

    <!-- Mobile bottom navigation bar -->
    <nav
      class="fixed inset-x-0 bottom-0 z-30 flex items-center justify-around border-t border-white/10 bg-slate-950/90 px-2 py-2 backdrop-blur-xl lg:hidden">
      <button
        @click="sidebarOpen = true"
        class="flex flex-col items-center gap-1 rounded-xl px-4 py-1.5 text-white/60 transition hover:text-white">
        <i class="fa-solid fa-comments text-lg"></i>
        <span class="text-[10px] font-medium">Chats</span>
      </button>
      <button
        class="flex flex-col items-center gap-1 rounded-xl px-4 py-1.5 text-white/60 transition hover:text-white">
        <i class="fa-solid fa-bolt text-lg"></i>
        <span class="text-[10px] font-medium">Activity</span>
      </button>
      <button
        class="flex flex-col items-center gap-1 rounded-xl px-4 py-1.5 text-white/60 transition hover:text-white">
        <i class="fa-solid fa-calendar-days text-lg"></i>
        <span class="text-[10px] font-medium">Calendar</span>
      </button>
      <a href="/logout"
        class="flex flex-col items-center gap-1 rounded-xl px-4 py-1.5 text-white/60 transition hover:text-white">
        <i class="fa-solid fa-gear text-lg"></i>
        <span class="text-[10px] font-medium">Settings</span>
      </a>
      <div
        class="flex flex-col items-center gap-1 rounded-xl px-4 py-1.5 text-emerald-300">
        <div class="flex h-7 w-7 items-center justify-center rounded-xl border border-emerald-300/30 bg-emerald-400/10 text-xs font-bold text-emerald-100">
          FZ
        </div>
        <span class="text-[10px] font-medium">Me</span>
      </div>
    </nav>
  </div>
</template>

