<template>
  <div class="flex justify-around py-6 border-b border-gray-300 rounded-lg">
    <DefaultLogo class="w-26" :link="'/'" />
    <div class="flex gap-4">
      <UserMyAccount />
      <UserLogout />
    </div>
  </div>
</template>

<script setup>
import DefaultLogo from '../common/DefaultLogo.vue';
import UserLogout from '../features/user/UserLogout.vue';
import UserMyAccount from '../features/user/UserMyAccount.vue';
</script>

