<template>
  <div class="settings-login">
    <div class="login-container glass">
      <div class="login-header">
        <h1>Вход в настройки</h1>
        <p>Введите логин и пароль для доступа к панели управления</p>
      </div>

      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-field">
          <label for="username" class="form-label">Логин</label>
          <input
            id="username"
            v-model="form.username"
            type="text"
            class="form-input"
            placeholder="Введите логин"
            required
            autocomplete="username"
          />
        </div>

        <div class="form-field">
          <label for="password" class="form-label">Пароль</label>
          <div class="password-wrapper">
            <input
              id="password"
              v-model="form.password"
              :type="showPassword ? 'text' : 'password'"
              class="form-input"
              placeholder="Введите пароль"
              required
              autocomplete="current-password"
            />
            <button
              type="button"
              class="toggle-password"
              @click="showPassword = !showPassword"
            >
              <Eye v-if="!showPassword" :size="20" />
              <EyeOff v-else :size="20" />
            </button>
          </div>
        </div>

        <div v-if="error" class="error-message">
          <AlertCircle :size="20" />
          <span>{{ error }}</span>
        </div>

        <button type="submit" class="btn btn-large" :disabled="isLoading">
          <Loader2 v-if="isLoading" :size="20" class="spinner" />
          <span v-else>Войти</span>
        </button>
      </form>

      <div class="login-footer">
        <a href="/" class="back-link">
          <ArrowLeft :size="16" />
          Вернуться на главную
        </a>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Eye, EyeOff, AlertCircle, Loader2, ArrowLeft } from 'lucide-vue-next'

const router = useRouter()
const route = useRoute()

const form = reactive({
  username: '',
  password: ''
})

const showPassword = ref(false)
const isLoading = ref(false)
const error = ref('')

const LOGIN_CREDENTIALS = {
  username: 'Adam',
  password: 'CGJ-Ge-90'
}

const handleLogin = async () => {
  error.value = ''
  isLoading.value = true

  // Имитация задержки для UX
  await new Promise(resolve => setTimeout(resolve, 500))

  if (form.username === LOGIN_CREDENTIALS.username && form.password === LOGIN_CREDENTIALS.password) {
    sessionStorage.setItem('settings_authenticated', 'true')
    const redirect = route.query.redirect || '/settings/dashboard'
    router.push(redirect)
  } else {
    error.value = 'Неверный логин или пароль'
    isLoading.value = false
  }
}

onMounted(() => {
  // Если уже авторизован, перенаправить на dashboard
  if (sessionStorage.getItem('settings_authenticated') === 'true') {
    router.push('/settings/dashboard')
  }
})
</script>

<style scoped>
.settings-login {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background: var(--dark);
  position: relative;
  overflow: hidden;
}

.settings-login::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    radial-gradient(circle at 20% 30%, rgba(99, 102, 241, 0.1) 0%, transparent 60%),
    radial-gradient(circle at 80% 70%, rgba(59, 130, 246, 0.1) 0%, transparent 60%);
  pointer-events: none;
  z-index: 0;
}

.login-container {
  width: 100%;
  max-width: 450px;
  position: relative;
  z-index: 1;
  padding: 3rem;
}

.login-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.login-header h1 {
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.login-header p {
  color: rgba(255, 255, 255, 0.7);
  font-size: 1rem;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-field {
  display: flex;
  flex-direction: column;
}

.form-label {
  margin-bottom: 0.5rem;
  color: var(--white);
  font-weight: 500;
  font-size: 0.9375rem;
}

.form-input {
  width: 100%;
  padding: 0.875rem 1rem;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: var(--white);
  font-size: 1rem;
  font-family: inherit;
  transition: all 0.2s ease;
}

.form-input:focus {
  outline: none;
  border-color: var(--primary);
  background: rgba(255, 255, 255, 0.05);
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
}

.password-wrapper {
  position: relative;
}

.toggle-password {
  position: absolute;
  right: 0.75rem;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.5);
  cursor: pointer;
  padding: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: color 0.2s ease;
}

.toggle-password:hover {
  color: var(--white);
}

.error-message {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem;
  background: rgba(239, 68, 68, 0.1);
  border: 1px solid rgba(239, 68, 68, 0.3);
  border-radius: 8px;
  color: #f87171;
  font-size: 0.9375rem;
}

.btn {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.login-footer {
  margin-top: 2rem;
  text-align: center;
}

.back-link {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  font-size: 0.9375rem;
  transition: color 0.2s ease;
}

.back-link:hover {
  color: var(--primary-light);
}

@media (max-width: 768px) {
  .settings-login {
    padding: 1rem;
  }

  .login-container {
    padding: 2rem 1.5rem;
  }

  .login-header h1 {
    font-size: 1.5rem;
  }
}
</style>
