const url = import.meta.env.VITE_BACKEND_URL ?? 'http://localhost:3000/';

export async function requireAuth(to, from, next) {
  const isLoggedIn = await checkAuth();
  if (!isLoggedIn) {
    next('/login');
  } else {
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
    const response = await fetch(`${url}me`, { credentials: 'include' });
    const data = await response.json();
    return data.id;
  }catch (error) {
    console.error('Erro ao verificar autenticacao: ', error)
    return false
  }
}
