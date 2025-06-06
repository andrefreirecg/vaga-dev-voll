<script setup lang="ts">

import { computed, onMounted, ref, watch } from 'vue';
import backgroundGif from '@/assets/images/background-login.gif'
import CardLogin from '@/components/layout/CardLogin.vue';
import { userStore } from '@/stores/user';
import { useRouter } from 'vue-router'
const store = userStore();
const router = useRouter()

watch(() => store.id, (newId) => {
  if (newId) {
    router.push('/');
  }
});

onMounted(() => {
  console.log(store.id)
  if (store.id) {
    router.push('/');
  }
})

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
