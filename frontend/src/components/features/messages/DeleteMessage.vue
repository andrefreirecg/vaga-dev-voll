<template>
  <div>
    <form @submit="onSubmit">
      <button type="submit"
        class="inline-flex w-full justify-center rounded-full text-gray-300 hover:text-gray-800 p-1 text-sm shadow-xs ring-1 ring-gray-300 ring-inset hover:bg-gray-50">
        <TrashCan />
      </button>
    </form>
  </div>
</template>

<script setup>
import TrashCan from 'vue-material-design-icons/TrashCan.vue';
import { messagesStore } from '@/stores/messages';
const store_messages = messagesStore();
import { defineProps } from 'vue';
import { toast } from 'vue3-toastify';
const props = defineProps({ message_id: { type: String, required: true } });

async function onSubmit(e) {
  e.preventDefault();
  const deleted = await store_messages.delete_message(props.message_id);
  if (!deleted.status) {
    toast('Erro ao deletar mensagem, tente novamente mais tarde', {
      position: toast.POSITION.BOTTOM_RIGHT,
      type: 'error',
      autoClose: true,
      closeOnClick: true,
      closeButton: true
    });
    return
  }
  toast('Mensagem excluida com sucesso', {
    position: toast.POSITION.BOTTOM_RIGHT,
    type: 'success',
    autoClose: true,
    closeOnClick: true,
    closeButton: true
  });
}
</script>
