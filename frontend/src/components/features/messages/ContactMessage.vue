<template>
  <div class="p-1" v-if="message.content">
      <div class="flex items-center p-1 gap-2 w-full justify-between px-3">
        <div class="w-8 h-8 bg-gray-500 rounded-full flex justify-center items-center">
          {{ store_user.name.charAt(0) }}
        </div>
        <div class="w-full">
          <p class="text-sm text-left font-bold">{{ store_user.name }}</p>
          <p class="text-gray-300 text-left text-md">
            {{ message.content }}
          </p>
          <div class="text-xs justify-start flex">
            <small class="text-gray-500">{{ new Date(message.created_at) != new Date(message.updated_at) ?
              date_to_ptbr(message.updated_at) + ' (editado)' : date_to_ptbr(message.created_at) != message.updated_at
                ? date_to_ptbr(message.updated_at) + ' (editado)' : date_to_ptbr(message.created_at) }}</small>
          </div>
        </div>
      </div>
  </div>
</template>

<script setup>
import { userStore } from '@/stores/user';
import { date_to_ptbr } from '@/utils/date';
import { defineProps } from 'vue';
const store_user = userStore();

const props = defineProps({ message: { type: Object } });
</script>
