const url = import.meta.env.VITE_BACKEND_URL ?? 'http://localhost:3000/';

import { defineStore } from 'pinia';
export const userStore = defineStore('user', {
  state: () => {
    return {
      id: '',
      name: '',
      created_at: new Date(),
      last_login_at: new Date(),
    };
  },
  actions: {
    setUser(user: any) {
      this.id = user.id;
      this.name = user.name;
      this.created_at = user.created_at;
      this.last_login_at = user.last_login_at;
    },
    deleteUser() {
      this.id = '';
      this.name = '';
      this.created_at = new Date();
      this.last_login_at = new Date();
      document.cookie = 'auth=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
    },
    async login(body: any) {
      try {
        const body_string = JSON.stringify(body);
        const response = await fetch(`${url}login`, {
          method: 'POST',
          credentials: 'include',
          headers: {
            'Content-Type': 'application/json',
          },
          body: body_string
        });
        const data = await response.json()
        if (response.ok) {
          this.setUser(data.user);
          await new Promise(resolve => setTimeout(resolve, 200));
          return {
            status: true,
            message: 'Login realizado com sucesso'
          }
        } else {
          return {
            status: false,
            message: data.error
          }
        }
      } catch (error) {
        console.error('Erro ao enviar solicitacao de login: ', error)
      }
      return {
        status: false,
        message: 'Erro ao enviar solicitacao de login'
      }
    },
    async logout() {
      try {
        await fetch(`${url}logout`, {
          method: 'POST',
          credentials: 'include',

        });
        this.deleteUser();
        return {
          status: true,
          message: 'Logout realizado com sucesso'
        }
      } catch (error) {
        console.error('Erro ao fazer logout: ', error)
        return {
          status: false,
          message: 'Erro ao fazer logout'
        }
      }
    },
  },
});
