const url = import.meta.env.VITE_BACKEND_URL ?? 'http://localhost:3000/';

import { defineStore } from 'pinia';
export const messagesStore = defineStore('messages', {
  state: () => {
    return {
      conversations: [],
      messages: [],
      currentPage: 0,
      perPage: 10,
      hasMoreMessages: true,
      loadingMessages: false
    };
  },
  actions: {
    addConversation(conversation: any) {
      if (!this.conversations.find((c: any) => c.id === conversation.id)) {
        this.conversations.push(conversation);
      }
    },
    removeConversation(id_conversation: string) {
      this.conversations = this.conversations.filter((c: any) => c.id !== id_conversation);
    },
    addMessage(message: any) {
      if (!this.messages.find((m: any) => m.id === message.id)) {
        this.messages.push(message);
      }
      const conversation = this.conversations.find((c: any) => c.id === message.conversation_id);
      if (conversation) {
        conversation.messages[0] = message;
      }
    },
    removeMessage(id_message: string) {
      this.messages = this.messages.filter((m: any) => m.id !== id_message);
    },
    updateMessage(message: any) {
      const index = this.messages.findIndex((m: any) => m.id === message.id);
      if (index !== -1) {
        this.messages[index] = message;
      }
    },
    reset_pagination() {
      this.currentPage = 0;
      this.hasMoreMessages = true;
    },
    clear_all() {
      this.conversations = [];
      this.messages = [];
    },
    async new_conversation(body: any) {
      try {
        const body_string = JSON.stringify(body);
        const response = await fetch(`${url}conversations`, {
          method: 'POST',
          credentials: 'include',
          headers: {
            'Content-Type': 'application/json',
          },
          body: body_string
        });
        const data = await response.json()
        if (response.ok) {
          this.addConversation(data.conversation);
          return {
            status: true,
            message: 'Conversa adicionada'
          }
        } else {
          if (data?.conversation) {
            this.addConversation(data.conversation);
          }
          return {
            status: false,
            message: data.errors[0]
          }
        }
      } catch (error) {
        console.error('Erro ao adicionar conversa ao store: ', error)
        return {
          status: false,
          message: 'Erro desconhecido ao adicionar conversa ao store'
        }
      }
    },
    async delete_conversation(id_conversation: string, id_user: string) {
      try {
        const body = {
          id_conversation: id_conversation,
          id_user: id_user
        }
        const body_string = JSON.stringify(body);
        await fetch(`${url}conversations`, {
          method: 'DELETE',
          credentials: 'include',
          body: body_string,
          headers: {
            'Content-Type': 'application/json',
          }
        });
        this.removeConversation(id_conversation);
        return {
          status: true,
          message: 'Conversa deletada'
        }
      } catch (error) {
        console.error('Erro ao deletar conversa: ', error)
        return {
          status: false,
          message: 'Erro ao deletar'
        }
      }
    },
    async get_conversations(id_user: string) {
      try {
        const response = await fetch(`${url}conversations/user/${id_user}`, {
          method: 'GET',
          credentials: 'include',
        });
        const data = await response.json()
        if (response.ok) {
          new Promise((resolve, reject) => {
            data.conversations.forEach((conversation: any) => {
              this.addConversation(conversation);
            })
            resolve(true);
          })
          return {
            status: true,
            message: 'Conversas carregadas com sucesso',
            conversations: this.conversations
          }
        } else {
          return {
            status: false,
            message: data.error
          }
        }
      } catch (error) {
        console.error('Erro ao carregar conversas: ', error)
        return {
          status: false,
          message: 'Erro ao carregar'
        }
      }
    },
    async send_message(body: any) {
      try {
        const body_string = JSON.stringify(body);
        const response = await fetch(`${url}messages`, {
          method: 'POST',
          credentials: 'include',
          headers: {
            'Content-Type': 'application/json',
          },
          body: body_string
        });
        const data = await response.json()
        if (response.ok) {
          this.addMessage(data.data);
          return {
            status: true,
            message: 'Mensagem enviada'
          }
        } else {
          if (data?.data) {
            this.addMessage(data.data);
          }
          return {
            status: false,
            message: data.errors[0]
          }
        }
      } catch (error) {
        console.error('Erro ao enviar mensagem ao store: ', error)
        return {
          status: false,
          message: 'Erro desconhecido ao enviar mensagem'
        }
      }
    },
    async get_messages(id_conversation: string) {
      this.currentPage = 1;
      this.hasMoreMessages = true;
      this.messages = []; // zera mensagens antes de carregar
      return await this.load_more_messages(id_conversation);
    },

    async load_more_messages(id_conversation: string) {
      if (!this.hasMoreMessages || this.loadingMessages) return;

      this.loadingMessages = true;

      try {
        const response = await fetch(`${url}messages/conversation/${id_conversation}?page=${this.currentPage}&per_page=${this.perPage}`, {
          method: 'GET',
          credentials: 'include',
        });

        const data = await response.json();

        if (response.ok) {
          if (data.messages.length < this.perPage) {
            this.hasMoreMessages = false;
          }

          this.messages = [...data.messages, ...this.messages];
          this.currentPage += 1;

          return {
            status: true,
            message: 'Mais mensagens carregadas com sucesso',
            messages: this.messages
          }
        } else {
          return {
            status: false,
            message: data.error
          }
        }
      } catch (error) {
        console.error('Erro ao carregar mais mensagens: ', error)
        return {
          status: false,
          message: 'Erro ao carregar mais mensagens'
        }
      } finally {
        this.loadingMessages = false;
      }
    },
    async delete_message(id_message: string) {
      try {
        await fetch(`${url}messages/${id_message}`, {
          method: 'DELETE',
          credentials: 'include',
          headers: {
            'Content-Type': 'application/json',
          }
        });
        this.removeMessage(id_message);
        return {
          status: true,
          message: 'Mensagem deletada'
        }
      } catch (error) {
        console.error('Erro ao deletar mensagem: ', error)
    }
    }
  }
});
