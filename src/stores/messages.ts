const url = import.meta.env.VITE_BACKEND_URL ?? 'http://localhost:3000/';

import { defineStore } from 'pinia';
export const messagesStore = defineStore('messages', {
  state: () => {
    return {
      conversations: [],
      messages: []
    };
  },
  actions: {
    addConversation (conversation: any) {
      if (!this.conversations.find((c: any) => c.id === conversation.id)) {
        this.conversations.push(conversation);
      }
    },
    removeConversation (id_conversation: string) {
      this.conversations = this.conversations.filter((c: any) => c.id !== id_conversation);
    },
    clear_all(){
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
    }
  },
});
