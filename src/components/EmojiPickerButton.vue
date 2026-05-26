<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import { Picker } from 'emoji-mart';
import data from '@emoji-mart/data';

const props = defineProps({
  // 'emerald' for channels, 'sky' for DMs — drives the button hover colour
  accent: { type: String, default: 'emerald' },
});

const emit = defineEmits(['select']);

const open = ref(false);
const wrapperEl = ref(null);
const mountEl = ref(null);

// Close when clicking outside the wrapper
function onDocClick(e) {
  if (wrapperEl.value && !wrapperEl.value.contains(e.target)) {
    open.value = false;
  }
}

onMounted(() => {
  // Mount div is always in the DOM (v-show), so we can append once here
  const picker = new Picker({
    data,
    theme: 'dark',
    previewPosition: 'none',
    skinTonePosition: 'search',
    onEmojiSelect(emoji) {
      emit('select', emoji.native);
      open.value = false;
    },
  });
  mountEl.value.appendChild(picker);

  document.addEventListener('mousedown', onDocClick, true);
});

onUnmounted(() => document.removeEventListener('mousedown', onDocClick, true));
</script>

<template>
  <div ref="wrapperEl" class="relative">
    <!-- Toggle button -->
    <button
      type="button"
      @click="open = !open"
      :class="[
        'flex h-8 w-8 items-center justify-center rounded-xl text-base transition',
        accent === 'sky'
          ? 'text-slate-400 hover:bg-sky-400/10 hover:text-sky-300'
          : 'text-slate-400 hover:bg-emerald-400/10 hover:text-emerald-300',
      ]"
      title="Emoji"
    >
      😊
    </button>

    <!-- Picker popup — floats above the composer bar, always mounted -->
    <div
      v-show="open"
      ref="mountEl"
      class="absolute bottom-[calc(100%+0.75rem)] right-0 z-50 overflow-hidden rounded-2xl shadow-2xl"
    />
  </div>
</template>
