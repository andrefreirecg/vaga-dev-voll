<template>
  <RouterLink
    v-if="isClickable"
    :to="props.link === true ? defaultLink : props.link"
    :style="{ backgroundImage: `url(${background_logo})` }"
    :class="[className, props.class]"
  ></RouterLink>

  <div
    v-else
    :style="{ backgroundImage: `url(${background_logo})` }"
    :class="[className, props.class]"
  ></div>
</template>

<script setup>
import background_logo from '../../assets/images/logo.png';
import { computed } from 'vue';
import { RouterLink } from 'vue-router';

const props = defineProps({
  class: {
    type: String,
    default: '',
  },
  link: {
    type: [String, Boolean],
    default: '',
  }
});

const defaultLink = '/home';

const className = computed(() =>
  `logo min-w-10 min-h-10 bg-center bg-contain bg-no-repeat ${props.class}`
);

const isClickable = computed(() => !!props.link);
</script>
