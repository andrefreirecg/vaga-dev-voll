<template>
  <div
    :style="{ backgroundImage: `url(${background_logo})` }"
    :class="[className, props.class]"
  ></div>
</template>

<script setup>
import background_logo from '../../assets/images/logo.png';
import { computed } from 'vue';

const props = defineProps({
  class: {
    type: String,
    default: '',
  },
});

const className = computed(() =>
  `logo min-w-10 min-h-10 bg-center bg-contain bg-no-repeat ${props.class}`
);
</script>
