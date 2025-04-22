import { createRouter, createWebHistory } from 'vue-router'

import LoginView from '@/views/LoginView.vue';
import HomeView from '@/views/HomeView.vue'
import MyAccountView from '@/views/MyAccountView.vue';

import { requireAuth, guestOnly } from '@/middleware/auth'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Home',
      component: HomeView,
      beforeEnter: requireAuth
    },
    {
      path: '/login',
      name: 'Login',
      component: LoginView,
      beforeEnter: guestOnly
    },
    {
      path: '/my-account',
      name: 'Minha conta',
      component: MyAccountView,
      beforeEnter: requireAuth
    },
  ],
})

export default router
