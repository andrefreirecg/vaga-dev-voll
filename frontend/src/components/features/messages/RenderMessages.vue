<template>
  <div class="flex flex-col h-[100dvh]" v-if="conversation_id && current_conversation">
    <div class="flex justify-between uppercase p-2 shrink-0">
      <div>
        <h2 class="text-lg font-bold text-gray-400 mb-2">
          {{
            store_user.id === current_conversation.user_a.id
              ? current_conversation.user_b.name
              : current_conversation.user_a.name
          }}
        </h2>
        <small>Conversa iniciada em: {{ date_to_ptbr(current_conversation.created_at) }}</small>
      </div>
      <DeleteConversation :conversation_id="current_conversation.id" />
    </div>
    <div ref="scroll_container" class="flex-1 overflow-y-auto px-2">
      <div v-if="!store_messages.hasMoreMessages" class="text-center text-gray-500 mb-1">
        Não há mais nada por aqui
      </div>
      <div v-if="store_messages.hasMoreMessages" ref="loadTrigger" class="h-4" />
      <div>
        <div v-for="message in current_messages" :key="message.id">
          <OwnMessage :message="message" v-if="store_user.id == message.user_id" />
          <ContactMessage :message="message" v-else />
        </div>
      </div>
      <div ref="endOfMessages" />
    </div>
    <div class="border-t mt-2 pb-3 px-2 ">
      <NewMessage :conversation_id="conversation_id" />
    </div>
  </div>
  <div v-else class="flex items-center justify-center h-full gap-3">
    <MessageBulletedOff />
    <p class="text-lg uppercase font-bold">Selecione uma conversa</p>
  </div>
  <p class="self-end" v-if="conversation_id && !current_conversation">Espertinho! Nada pra você aqui</p>
</template>



<script setup>
import MessageBulletedOff from 'vue-material-design-icons/MessageBulletedOff.vue';
import DeleteConversation from '@/components/features/conversations/DeleteConversation.vue';
import { date_to_ptbr } from '@/utils/date';
import { ref, computed, nextTick, onMounted, onBeforeUnmount, defineProps, watch } from 'vue';
import { messagesStore } from '@/stores/messages';
import { userStore } from '@/stores/user';
import cable from '@/utils/cable'
import OwnMessage from './OwnMessage.vue';
import ContactMessage from './ContactMessage.vue';
import NewMessage from './NewMessage.vue';
import { toast } from 'vue3-toastify';
const store_messages = messagesStore();
const store_user = userStore();
const props = defineProps({ conversation_id: { type: String, required: false } })

const current_conversation = computed(() => store_messages.conversations.find((conversation) => conversation.id === props.conversation_id));
const endOfMessages = ref(null)
const current_messages = computed(() =>
  store_messages.messages
    .filter((message) => message.conversation_id === props.conversation_id)
    .sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
);

const loadTrigger = ref(null);
const scroll_container = ref(null);
let observer;
let userSubscription = null;

watch(current_messages, async () => {
  await nextTick()
  if (endOfMessages.value) {
    endOfMessages.value.scrollIntoView({ behavior: 'smooth' })
  }
})

watch(() => props.conversation_id, async (newId) => {
  if (observer && loadTrigger.value) {
    observer.unobserve(loadTrigger.value);
  }

  await store_messages.get_messages(newId);

  await nextTick();
  if (endOfMessages.value) {
    endOfMessages.value.scrollIntoView({ behavior: 'auto' });
  }

  if (loadTrigger.value) {
    observer.observe(loadTrigger.value);
  }
});


onMounted(async () => {
  await store_messages.get_messages(props.conversation_id)

  await nextTick()

  if (endOfMessages.value) {
    endOfMessages.value.scrollIntoView({ behavior: 'auto' })
  }
  await nextTick()

  observer = new IntersectionObserver(async ([entry]) => {
    if (entry.isIntersecting) {
      console.log('Carregando mais mensagens...');

      const container = scroll_container.value;
      const scrollHeightBefore = container.scrollHeight;
      const scrollTopBefore = container.scrollTop;

      if (props.conversation_id) {
        await store_messages.load_more_messages(props.conversation_id);

        await nextTick();

        const scrollHeightAfter = container.scrollHeight;
        const scrollDiff = scrollHeightAfter - scrollHeightBefore;

        container.scrollTop = scrollTopBefore + scrollDiff;
      }
    }
  }, {
    root: scroll_container.value,
    rootMargin: '0px',
    threshold: 1.0,
  });

  if (loadTrigger.value) {
    observer.observe(loadTrigger.value);
  }

  userSubscription = cable.subscriptions.create(
  { channel: 'UserChannel', user_id: store_user.id },
    {
      received(data) {
        if (data.type == "message_deleted") {
          store_messages.removeMessage(data.message.id);
        }else{
          store_messages.addMessage(data.message);
        }
      },
      connected() {
        toast('Conectado, você receberá novas mensagens automaticamente', {
          position: toast.POSITION.BOTTOM_RIGHT,
          type: 'success',
          autoClose: true,
          closeOnClick: true,
          closeButton: true
        })
      },
      disconnected() {
        toast('Desconectado do canal do usuário, você não receberá mais mensagens sem atualização da página', {
          position: toast.POSITION.BOTTOM_RIGHT,
          type: 'warning',
          autoClose: true,
          closeOnClick: true,
          closeButton: true
        })
      }
    }
  );

})

onBeforeUnmount(() => {
  if (observer && loadTrigger.value) {
    observer.unobserve(loadTrigger.value);
  }

  if (userSubscription) {
    cable.subscriptions.remove(userSubscription);
  }
});

</script>
