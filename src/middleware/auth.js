const url = import.meta.env.VITE_BACKEND_URL ?? 'http://localhost:3000/';
import { userStore } from '@/stores/user';
import { messagesStore } from '@/stores/messages';
export async function requireAuth(to, from, next) {
  const isLoggedIn = await checkAuth();
  if (!isLoggedIn) {
    next('/login');
  } else {
    userStore().setUser(isLoggedIn);
    await messagesStore().get_conversations(isLoggedIn.id);
    next();
  }
}


export async function guestOnly(to, from, next) {
  const isLoggedIn = await checkAuth();
  if (isLoggedIn) {
    next('/');
  } else {
    next();
  }
}

async function checkAuth() {
  try{
    const request = await fetch(`${url}me`, { credentials: 'include' });
    const data = await request.json();
    return data.user;
  }catch (error) {
    console.error('Erro ao verificar autenticacao: ', error)
    return false
  }
}
