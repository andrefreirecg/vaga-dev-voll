<template>
  <div class="flex flex-col" v-if="current">
    <div class="flex items-center justify-between p-1 cursor-pointer hover:text-black hover:bg-gray-100 ">
      <div class="flex items-center p-1 gap-2 w-full justify-between px-2">
        <div class="w-8 h-8 bg-gray-500 rounded-full flex justify-center items-center">
          {{ current.name.charAt(0) }}
        </div>
        <div>
          <p class="text-sm text-right font-bold">{{ current.name }}</p>
          <p class="text-xs text-gray-600 flex items-center justify-between" v-if="current.last_message">
            {{ `${(current.last_message.user_id == store_user.id ? 'Você' : current.name)}:
            ${(current.last_message.content ? truncateText(current.last_message.content)  : 'Arquivo')}` }}
          </p>
          <p v-else>
            Nenhuma mensagem
          </p>
          <div class="text-xs justify-end flex">
            <small class="text-gray-500">{{ current.last_message ?
              date_to_ptbr(current.last_message.created_at) : date_to_ptbr(current.created_at) }}</small>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps,computed } from 'vue';
import { date_to_ptbr } from '@/utils/date';
import { userStore } from '@/stores/user';
const store_user = userStore();

const props = defineProps({
  conversation: Object
});
const current = computed(() => props.conversation)

function truncateText(text, length = 20) {
  return text.length > length ? text.slice(0, length) + '...' : text;
}


</script>
