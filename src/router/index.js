import { createRouter, createWebHashHistory } from 'vue-router';
import WelcomePage from './pages/WelcomePage.vue';
import ChannelPage  from './pages/ChannelPage.vue';
import UserPage    from './pages/UserPage.vue';

const routes = [
  { path: '/',               component: WelcomePage },
  { path: '/channel/:slug/:id',   component: ChannelPage  },
  { path: '/user/:username/:id', component: UserPage    },
];

export default createRouter({
  history: createWebHashHistory(),
  routes,
});
