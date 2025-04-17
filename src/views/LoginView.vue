<script setup lang="ts">

import { ref } from 'vue';
import backgroundGif from '@/assets/images/background-login.gif'
import CardLogin from '@/components/CardLogin.vue';
const user_id = ref('');

</script>

<template>
  <div class="grid grid-cols-2 min-h-dvh">
    <div :style="{ backgroundImage: `url(${backgroundGif})` }" class="bg-cover bg-no-repeat bg-center min-h-vhd">

    </div>
    <div class="content min-h-dvh flex items-center justify-center">
      <CardLogin />
    </div>
  </div>
</template>
