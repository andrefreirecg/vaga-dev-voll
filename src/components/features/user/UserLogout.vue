<template>
  <div class="text-white">
    <button type="button" @click="user_logout">
      <IconsLogout fill="#fff" />
    </button>
  </div>
</template>

<script setup>

import IconsLogout from '../../icons/IconsLogout.vue';
import { userStore } from '@/stores/user';
import { messagesStore } from '@/stores/messages';
import { toast } from 'vue3-toastify';
const url = import.meta.env.VITE_BACKEND_URL ?? 'http://localhost:3000/';
import { useRouter } from 'vue-router'
const router = useRouter();
const messages_store = messagesStore();
async function user_logout(e) {
  e.preventDefault();
  const logout_toast = toast("Enviando solicitação",
    {
      position: toast.POSITION.BOTTOM_RIGHT,
      type: 'loading',
      isLoading: true,
      autoClose: true,
      closeOnClick: true,
      closeButton: true
    }
  )
  const logout = await userStore().logout();
  if (logout.status) {
    toast.update(logout_toast, {
      render: logout.message,
      autoClose: true,
      closeOnClick: true,
      closeButton: true,
      type: logout.status ? 'success' : 'error',
      isLoading: false,
    });
    messages_store.clear_all()
    router.push('/login');
  }
}
</script>
