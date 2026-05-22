import { createApp } from 'vue';
import HomeChatComposer from './HomeChatComposer.vue';
import { addSocketEvent, initWebSocket } from './socket_client';
import router from '../router/index.js';

const homeComposerRoot = document.getElementById('chat-home-vue');
initWebSocket();

if (homeComposerRoot) {
  var app = createApp(HomeChatComposer);
  app.use(router);
  app.config.globalProperties.$addSocketEvent = addSocketEvent;
  app.config.globalProperties.$initWebSocket = initWebSocket;
  app.mount(homeComposerRoot);
}
