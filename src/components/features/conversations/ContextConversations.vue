<template>

  <NewConversation />
  <div class="flex flex-col min-w-full" v-if="conversations.length > 0">
    <div v-for="conversation in conversations" :key="conversation.id" @click="select_conversation(conversation.id)">
      <div class="flex flex-col">
        <div class="flex items-center justify-between p-1 cursor-pointer hover:text-black hover:bg-gray-100 ">
          <div class="flex items-center p-1 gap-2 w-full justify-around">
            <div class="w-8 h-8 bg-gray-500 rounded-full flex justify-center items-center">
              {{ conversation.name.charAt(0) }}
            </div>
            <div>
              <p class="text-sm text-right font-bold">{{ conversation.name }}</p>
              <p class="text-xs text-gray-600 flex items-center justify-between" v-if="conversation.last_message">
                {{ `${(conversation.last_message.user_id == store_user.id ? 'Você' : conversation.name)}:
                ${(conversation.last_message.content ? conversation.last_message.content : 'Arquivo')}` }}
              </p>
              <p v-else>
                Nenhuma mensagem
              </p>
              <div class="text-xs justify-end flex">
                <small class="text-gray-500">{{ conversation.last_message ? date_to_ptbr(conversation.last_message.created_at) : date_to_ptbr(conversation.created_at) }}</small>
              </div>
            </div>
          </div>
        </div>
      </div>
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
import { format, parseISO } from 'date-fns';
import { ptBR } from 'date-fns/locale';

const store_messages = messagesStore();
const store_user = userStore();

const conversations = computed(() => parse_conversations_from_store());

const router = useRouter();

function date_to_ptbr(rawDate) {
  if (!rawDate) return 'Data inválida';

  try {
    const parsed = parseISO(rawDate);
    return format(parsed, "dd 'de' MMMM 'de' yyyy 'às' HH:mm", { locale: ptBR });
  } catch (e) {
    console.error('Erro ao formatar data:', e);
    return '';
  }
}

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
