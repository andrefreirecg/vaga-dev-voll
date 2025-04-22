<template>
  <div class="text-white">
    <button type="button" @click="user_logout">
      <IconsLogout fill="#fff" />
    </button>
  </div>
</template>

<script setup>

import IconsLogout from '../../icons/IconsLogout.vue';
import { toast } from 'vue3-toastify';
const url = import.meta.env.VITE_BACKEND_URL ?? 'http://localhost:3000/';
import { useRouter } from 'vue-router'
const router = useRouter();

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

  try {
    const response = await fetch(`${url}logout`, {
      method: 'POST',
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json'
      },
    });
    if (response.ok) {
      toast.update(logout_toast, {
        render: "Voce foi desconectado com sucesso",
        autoClose: true,
        closeOnClick: true,
        closeButton: true,
        type: 'success',
        isLoading: false,
      });
      router.push('/login');
    }
    const data = await response.json();
    toast.update(logout_toast, {
      render: data.error,
      autoClose: true,
      closeOnClick: true,
      closeButton: true,
      type: 'error',
      isLoading: false,
    });
  } catch (error) {
    console.error(error);
    toast.update(logout_toast, {
      render: "Erro ao enviar solicitação, não foi possível se comunicar com o servidor",
      autoClose: true,
      closeOnClick: true,
      closeButton: true,
      type: 'error',
      isLoading: false,
    });
  }
}
</script>
