<template>
  <div class="border-white border-2 mx-10 rounded-2xl flex flex-col w-[80%] ">
    <div class="login-header flex justify-center">
      <DefaultLogo />
    </div>
    <h2 class="text-2xl mb-4 font-black self-center uppercase">Bem-vindo de volta!</h2>

    <div class="login-content flex flex-col w-[80%] self-center gap-4">
      <p class="text-gray-600 mb-4 self-end">Faça login para continuar.</p>
      <form class="flex justify-center flex-col gap-3" @submit="login_user">
        <div class="flex flex-col">
          <label for="user_id" class="text-gray-600 mb-2">ID do usuário / Nome de usuário</label>
          <input type="text" id="user_id" class="border border-gray-300 rounded-md px-3 py-2 mb-4" v-model="user_id">
        </div>
        <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded">Entrar</button>
      </form>
    </div>
    <footer class="py-5">
      <ModalCreateAccount />
    </footer>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router'
import { userStore } from '../../stores/user';
import DefaultLogo from '../common/DefaultLogo.vue';
import ModalCreateAccount from '../features/user/ModalCreateAccount.vue';

const router = useRouter()

import { toast } from 'vue3-toastify';

const user_id = ref('');
const emit = defineEmits(['login']);
function isUUID(str) {
  return /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/.test(str);
}

async function login_user(e) {
  e.preventDefault();
  let body = {
    user_id: user_id.value
  };

  if (!user_id.value) {
    toast("Por favor, insira um ID de usuário ou nome de usuário", {
      position: toast.POSITION.BOTTOM_RIGHT,
      type: 'warning',
      autoClose: true,
      closeOnClick: true,
      closeButton: true
    });
    return;
  }
  if (!isUUID(user_id.value)) {
    body = {
      name: user_id.value
    };
  }
  const login_toast = toast("Enviando solicitação",
    {
      position: toast.POSITION.BOTTOM_RIGHT,
      type: 'loading',
      isLoading: true,
      autoClose: true,
      closeOnClick: true,
      closeButton: true
    }
  )
  const logged = await userStore().login(body);
  toast.update(login_toast, {
    render: logged.message,
    autoClose: true,
    closeOnClick: true,
    closeButton: true,
    type: logged.status ? 'success' : 'error',
    isLoading: false,
  });
  if (logged.status) {
    router.push('/');
  }
}
</script>
