<template>
  <div class="flex flex-col h-[100dvh]">
    <div class="text-center uppercase p-2 shrink-0">
      <h2 class="text-lg font-bold text-gray-400 mb-2">
        {{
          store_user.id === current_conversation.user_a.id
            ? current_conversation.user_b.name
            : current_conversation.user_a.name
        }}
      </h2>
    </div>
    <div ref="scroll_container" class="flex-1 overflow-y-auto px-2">
      <div v-if="!store_messages.hasMoreMessages" class="text-center text-gray-500 mb-1">
        Não há mais nada por aqui
      </div>
      <div v-if="store_messages.hasMoreMessages" ref="loadTrigger" class="h-4" />
      <div>
        <div v-for="message in current_messages" :key="message.id">
          <OwnMessage :message="message" v-if="store_user.id == message.user_id"/>
          <ContactMessage :message="message" v-else />
        </div>
      </div>
      <div ref="endOfMessages" />
    </div>
    <div class="border-t mt-2 pb-3 px-2 ">
      <NewMessage :conversation_id="id_conversation" />
    </div>
  </div>
</template>



<script setup>
import { ref, computed, nextTick, onMounted, onBeforeUnmount, defineProps, watch } from 'vue';
import { messagesStore } from '@/stores/messages';
import { userStore } from '@/stores/user';
import { useRoute } from 'vue-router';
import cable from '@/utils/cable'
import OwnMessage from './OwnMessage.vue';
import ContactMessage from './ContactMessage.vue';
import NewMessage from './NewMessage.vue';
import { toast } from 'vue3-toastify';
const store_messages = messagesStore();
const store_user = userStore();
const props = defineProps({ conversation_id: { type: String, required: true } })

const id_conversation = useRoute().params.id
const current_conversation = computed(() => store_messages.conversations.find((conversation) => conversation.id === id_conversation));
const endOfMessages = ref(null)
let subscription = null
const current_messages = computed(() =>
  [...store_messages.messages].sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
);

const loadTrigger = ref(null);
const scroll_container = ref(null);
let observer;

watch(current_messages, async () => {
  await nextTick()
  if (endOfMessages.value) {
    endOfMessages.value.scrollIntoView({ behavior: 'smooth' })
  }
})

watch(() => props.conversation_id, async (newId) => {
  // Remove observer e subscription antigos
  if (observer && loadTrigger.value) {
    observer.unobserve(loadTrigger.value);
  }
  if (subscription) {
    cable.subscriptions.remove(subscription);
  }

  // Reset mensagens e recarrega
  await store_messages.get_messages(newId);

  await nextTick();
  if (endOfMessages.value) {
    endOfMessages.value.scrollIntoView({ behavior: 'auto' });
  }

  // Recria observer e subscription
  if (loadTrigger.value) {
    observer.observe(loadTrigger.value);
  }

  subscription = cable.subscriptions.create(
    {
      channel: 'ConversationChannel',
      conversation_id: newId,
    },
    {
      received(data) {
        store_messages.addMessage(data.message);
        nextTick(() => {
          if (endOfMessages.value) {
            endOfMessages.value.scrollIntoView({ behavior: 'smooth' });
          }
        });
      },
      connected() {
        toast.success('Conectado ao servidor');
      },
      disconnected() {
        toast.error('Desconectado do servidor');
      }
    }
  );
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

  subscription = cable.subscriptions.create(
    {
      channel: 'ConversationChannel',
      conversation_id: props.conversation_id,
    },
    {
      async received(data) {
        store_messages.addMessage(data.message)
        await nextTick()
        if (endOfMessages.value) {
          endOfMessages.value.scrollIntoView({ behavior: 'smooth' })
        }
      },
      connected() {
        toast('Conectado ao servidor', {
          position: toast.POSITION.BOTTOM_RIGHT,
          type: 'success',
          autoClose: true,
          closeOnClick: true,
          closeButton: true
        })
      },
      disconnected() {
        toast('Desconectado do servidor', {
          position: toast.POSITION.BOTTOM_RIGHT,
          type: 'error',
          autoClose: true,
          closeOnClick: true,
          closeButton: true
        })
      },
    }
  )
})


onBeforeUnmount(() => {
  if (observer && loadTrigger.value) {
    observer.unobserve(loadTrigger.value);
  }
  if (subscription) {
    cable.subscriptions.remove(subscription)
  }
});
</script>
