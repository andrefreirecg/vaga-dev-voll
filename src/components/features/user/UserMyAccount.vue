<template>
  <div class="text-white">
    <router-link to="/my-account" class="text-white hover:cursor-pointer flex gap-2 items-center">
      <span>{{store_user.name}}</span>
      <AccountEdit fill="#fff" />
    </router-link>
  </div>
</template>

<script setup>

import AccountEdit from 'vue-material-design-icons/AccountEdit.vue';
import { userStore } from '@/stores/user';
const store_user = userStore();

</script>
