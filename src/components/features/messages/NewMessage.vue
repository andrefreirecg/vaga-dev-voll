<template>
    <form class="flex justify-center flex-col gap-3" @submit="submit_message">
      <div class="grid grid-cols-12 gap-x-4">
        <label for="message" class="col-span-12 text-gray-600 mb-2">Sua mensagem</label>
        <input type="text" id="message" class="col-span-11 border  rounded-md px-3 py-2 mb-4" v-model="message">
        <button type="submit" class="col-span-1 flex justify-center items-center bg-blue-600 text-white rounded" @click="submit_message">
          <SendCheck />
        </button>
      </div>
    </form>
</template>

<script setup>

import SendCheck from 'vue-material-design-icons/SendCheck.vue';
import { ref, defineProps, computed } from 'vue';
import { toast } from 'vue3-toastify';
import { messagesStore } from '@/stores/messages';
const store_messages = messagesStore();
const message = ref('')

const props = defineProps({ conversation_id: { type: String } });

const body = computed(() => {
  return {
    content: message.value,
    conversation_id: props.conversation_id
  }
})


async function submit_message(e) {
  e.preventDefault()
  const sended = await store_messages.send_message(body.value)

  if (!sended.status) {
    toast(sended.message, {
      position: toast.POSITION.BOTTOM_RIGHT,
      type: 'error',
      autoClose: true,
      closeOnClick: true,
      closeButton: true
    });
    return
  }

  message.value = ''
}

</script>
