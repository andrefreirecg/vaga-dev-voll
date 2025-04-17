import Cookies from 'js-cookie'

export function requireAuth(to, from, next) {
  const jwt = Cookies.get('jwt');
  const isLoggedIn = !!jwt;

  if (!isLoggedIn) {
    next('/login');
  } else {
    next();
  }
}

export function guestOnly(to, from, next) {
  const isLoggedIn = Cookies.get('jwt');
  if (isLoggedIn) {
    next('/');
  } else {
    next();
  }
}
