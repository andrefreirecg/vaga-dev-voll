<template>
  <div class="text-white">
    <router-link to="/my-account" class="text-white hover:cursor-pointer">
      <IconsMyAccount fill="#fff" />
    </router-link>
  </div>
</template>

<script setup>

import IconsMyAccount from '../../icons/IconsMyAccount.vue';
import { useRouter } from 'vue-router'
const router = useRouter();

</script>
