<template>
  <div class="flex items-center gap-2 opacity-10 hover:opacity-100">
    <UpdateMessage :message="message" />
    <DeleteMessage :message="message" />
  </div>
</template>

<script setup>
import { defineProps } from 'vue';

import DeleteMessage from './DeleteMessage.vue';
import UpdateMessage from './UpdateMessage.vue';

const props = defineProps({ message: { type: Object } });
</script>
