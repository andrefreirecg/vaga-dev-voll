<template>
  <div class="flex flex-col items-end">
    <div class="text-white hover:cursor-pointer flex gap-2 items-center">
      <span>{{ store_user.name }}</span>
      <AccountEdit fill="#fff" />
    </div>
    <small>Membro desde: {{ date_to_ptbr(store_user.created_at) }}</small>
    <small>Último login: {{ date_to_ptbr(store_user.last_login_at) }}</small>
  </div>
</template>

<script setup>

import AccountEdit from 'vue-material-design-icons/AccountEdit.vue';
import { userStore } from '@/stores/user';
import { date_to_ptbr } from '@/utils/date';
const store_user = userStore();

</script>
