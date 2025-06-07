<script setup lang="ts">
import PrincipalHeader from '@/components/layout/PrincipalHeader.vue';
import ContextConversations from '@/components/features/conversations/ContextConversations.vue';
import RenderMessages from '@/components/features/messages/RenderMessages.vue';

import { onMounted, watch } from 'vue'
import { messagesStore } from '@/stores/messages'
import { useRoute } from 'vue-router';
const route = useRoute()
const store_messages = messagesStore();

onMounted(async () => {
  await store_messages.get_messages(route.params.id)
})
</script>

<template>

  <div class="h-screen flex flex-col max-h-[100%]">
    <PrincipalHeader />

    <main class="flex-1 container">
      <div class="grid grid-cols-1 lg:grid-cols-5 border border-white min-h-full">
        <div class="col-span-1 border min-h-full border-white overflow-y-auto">
          <ContextConversations />
        </div>
        <div class="col-span-4 flex flex-col ">
          <RenderMessages :conversation_id="route.params.id" />
        </div>
      </div>
    </main>
  </div>

</template>
