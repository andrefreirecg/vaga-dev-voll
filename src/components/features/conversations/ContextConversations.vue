<template>
  <NewConversation />
  <div class="flex flex-col min-w-full" v-if="conversations.length > 0">
    <div v-for="conversation in conversations" :key="conversation.id" @click="select_conversation(conversation.id)">
      <CardConversation :conversation="conversation" />
    </div>
  </div>
  <div v-else>
    <p class="text-center">Nenhuma conversa encontrada</p>
  </div>

</template>

<script setup>
import { computed } from 'vue';
import { useRouter } from 'vue-router';
import { messagesStore } from '@/stores/messages';
import { userStore } from '@/stores/user';
import NewConversation from './NewConversation.vue';

import CardConversation from './CardConversation.vue';

const store_messages = messagesStore();
const store_user = userStore();

const conversations = computed(() => parse_conversations_from_store());

const router = useRouter();

const select_conversation = (id) => {
  router.push(`/${id}`);
}

function parse_conversations_from_store() {

  const parsed = store_messages.conversations.map((conversation) => {
    const user = (conversation.user_a.id == store_user.id ? conversation.user_b : conversation.user_a);
    return {
      id: conversation.id,
      name: user.name,
      subname: user.id,
      created_at: conversation.created_at,
      last_message: conversation.messages[0]
    }
  })
  return parsed.sort((a, b) => {
      const dateA = a.last_message?.created_at || a.created_at;
      const dateB = b.last_message?.created_at || b.created_at;
      return new Date(dateB) - new Date(dateA);
    });
}

</script>
