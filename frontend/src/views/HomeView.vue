<script setup lang="ts">
import PrincipalHeader from '@/components/layout/PrincipalHeader.vue';
import ContextConversations from '@/components/features/conversations/ContextConversations.vue';
import RenderMessages from '@/components/features/messages/RenderMessages.vue';

</script>

<template>

  <div class="h-screen flex flex-col">
    <PrincipalHeader />

    <main class="flex-1 overflow-hidden container">
      <div class="grid grid-cols-1 lg:grid-cols-5 border border-white min-h-full">
        <div class="col-span-1 border min-h-full border-white overflow-y-auto">
          <ContextConversations />
        </div>
        <div class="col-span-4 overflow-y-auto flex items-center justify-center gap-3">
          <RenderMessages />
        </div>
      </div>
    </main>
  </div>

</template>
