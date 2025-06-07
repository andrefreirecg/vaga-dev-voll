<template>
  <div class="grid grid-cols-12">
    <div class="editar col-span-1 flex justify-center text-gray-700 items-center cursor-pointer hover:text-gray-200">
      <DropdownConfigMessages :message="message" />
    </div>
    <div class="col-span-11 p-1" v-if="message.content">
        <div class="flex items-center flex-row-reverse p-1 gap-2 w-full justify-between px-3">
          <div class="w-8 h-8 bg-gray-500 rounded-full flex justify-center items-center">
            {{ store_user.name.charAt(0) }}
          </div>
          <div class="w-full">
            <p class="text-sm text-right font-bold">{{ store_user.name }}</p>
            <p class="text-gray-300 text-right text-md">
              {{ message.content }}
            </p>
            <div class="text-xs justify-end flex">
              <small class="text-gray-500">{{ message.created_at == message.updated_at ? date_to_ptbr(message.created_at) : date_to_ptbr(message.updated_at) + ' (editado)' }}</small>
            </div>
          </div>
        </div>
    </div>
  </div>
</template>

<script setup>
import DropdownConfigMessages from './DropdownConfigMessages.vue';
import { userStore } from '@/stores/user';
import { date_to_ptbr } from '@/utils/date';
import { defineProps } from 'vue';
const store_user = userStore();

const props = defineProps({ message: { type: Object } });
</script>
