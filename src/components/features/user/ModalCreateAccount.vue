<template>
  <div class="flex items-center justify-center">
    <button @click="open = true" class="uppercase text-stone-300 font-bold hover:cursor-pointer">Criar Conta</button>
  </div>

  <div v-if="open" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md p-6 relative">
      <button @click="open = false" type="button" class="absolute top-2 right-2 text-gray-500 hover:text-gray-700">
        <IconsClose />
      </button>
      <h2 class="text-xl text-gray-900 font-bold mb-4">Criar Conta</h2>
      <form @submit="create_account" class="pb-3">
        <div class="flex flex-col">
          <label for="name" class="text-gray-600 mb-2">Nome de usuário <small>(Opcional)</small></label>
          <input type="text" id="name" class="border border-gray-300 text-gray-950 rounded-md px-3 py-2 mb-4"
            v-model="name">
        </div>
        <div class="flex gap-3 pt-2 justify-end">
          <button type="button" class="px-4 py-2 bg-gray-300 text-gray-800 rounded mr-2" @click="open = false">
            Cancelar
          </button>
          <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded">
            Confirmar
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>

import { ref } from 'vue'
import IconsClose from '../../icons/IconsClose.vue';
import { toast } from 'vue3-toastify';

const open = ref(false)
const name = ref('');

async function create_account(e) {
  e.preventDefault();
  let body = {
    name: name.value
  };
  const url = import.meta.env.VITE_BACKEND_URL ?? 'http://localhost:3000/';
  const create_account_toast = toast("Enviando solicitação",
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
    const response = await fetch(`${url}users`, {
      method: 'POST',
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(body)
    });
    const data = await response.json();
    if (response.ok) {
      toast.update(create_account_toast, {
        render: `Usuário criado com sucesso. O seu ID de acesso é: ${data.user.id} ou o seu nome de usuário: ${data.user.name}`,
        autoClose: false,
        closeOnClick: false,
        closeButton: true,
        isLoading: false,
        type: 'success',
      });
      open.value = false
      toast("Você precisa fazer login para continuar", {
        type: 'info',
        autoClose: true,
        closeOnClick: true,
        closeButton: true,
        isLoading: false
      })
    }else{
      toast.update(create_account_toast, {
        render: data.error,
        autoClose: true,
        closeOnClick: true,
        closeButton: true,
        type: 'error',
        isLoading: false,
      });
      open.value = false
    }
  } catch (error) {
    console.error(error);
    toast.update(create_account_toast, {
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
