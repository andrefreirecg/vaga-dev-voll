<template>
  <div class="flex items-center gap-2 opacity-10 hover:opacity-100">
    <DeleteMessage :message_id="message.id" />
  </div>
</template>

<script setup>
import { defineProps } from 'vue';

import DeleteMessage from './DeleteMessage.vue';

const props = defineProps({ message: { type: Object } });
</script>
