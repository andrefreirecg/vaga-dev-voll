<!-- <template>
  <div>
    <div class="flex items-center justify-between p-1 cursor-pointer hover:text-black hover:bg-gray-100">
      <div class="flex items-center p-1 gap-2">
        <div class="lg:w-8 lg:h-8 bg-gray-500 rounded-full flex justify-center items-center">
          +
        </div>
        <div class="ml-2">
          <p class="text-sm font-bold">Nova Conversa</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>

</script> -->

<template>
  <div class="flex items-center justify-between p-1 cursor-pointer hover:text-black hover:bg-gray-100"
    @click="open = true">
    <div class="flex items-center p-1 gap-2">
      <div class="lg:w-8 lg:h-8 bg-gray-500 rounded-full flex justify-center items-center">
        <plus />
      </div>
      <div class="ml-2">
        <p class="text-sm font-bold">Nova Conversa</p>
      </div>
    </div>
  </div>

  <div v-if="open" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md p-6 relative">
      <button @click="open = false" type="button" class="absolute top-2 right-2 text-gray-500 hover:text-gray-700">
        <AlphaX />
      </button>
      <h2 class="text-xl text-gray-900 font-bold mb-4">Nova Conversa</h2>
      <form @submit="new_conversation" class="pb-3">
        <div class="flex flex-col">
          <label for="name" class="text-gray-600 mb-2">Nome de usuário ou ID* <small>(OBRIGATÓRIO)</small></label>
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

import { toast } from 'vue3-toastify';
import { userStore } from '@/stores/user';
import { messagesStore } from '@/stores/messages';
const open = ref(false)
const name = ref('');
import Plus from 'vue-material-design-icons/Plus.vue';
import AlphaX from 'vue-material-design-icons/AlphaX.vue';

const user = userStore();
const messages = messagesStore();

async function new_conversation(e) {
  e.preventDefault();
  let body = {
    user_a_id: userStore().id,
    user_b_id: name.value
  };
  const new_conversation_toast = toast("Enviando solicitação",
    {
      position: toast.POSITION.BOTTOM_RIGHT,
      type: 'loading',
      isLoading: true,
      autoClose: true,
      closeOnClick: true,
      closeButton: true
    }
  )
  const new_conversation = await messages.new_conversation(body);
  if (new_conversation.status || new_conversation.message == 'Conversa já existe') {
    open.value = false
  }
  toast.update(new_conversation_toast, {
    render: new_conversation.message,
    autoClose: true,
    closeOnClick: true,
    closeButton: true,
    type: new_conversation.status ? 'success' : 'error',
    isLoading: false,
  });
}
</script>
