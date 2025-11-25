<template>
  <div class="offline-page">
    <div class="offline-background">
      <div class="gradient-orb orb-1"></div>
      <div class="gradient-orb orb-2"></div>
      <div class="gradient-orb orb-3"></div>
    </div>
    <div class="container">
      <div class="offline-content">
        <div class="offline-icon">
          <WifiOff :size="120" />
          <div class="icon-pulse"></div>
        </div>
        <h1 class="offline-title">Нет подключения к интернету</h1>
        <p class="offline-description">
          Похоже, что у вас отсутствует подключение к интернету.<br>
          Проверьте ваше соединение и попробуйте снова.
        </p>
        <div class="offline-status">
          <div class="status-item">
            <div class="status-dot" :class="{ online: isOnline }"></div>
            <span>{{ isOnline ? 'Подключение восстановлено' : 'Ожидание подключения...' }}</span>
          </div>
        </div>
        <div class="offline-actions">
          <button @click="reloadPage" class="btn btn-large" :disabled="!isOnline">
            <RefreshCw :size="20" :class="{ spinning: isReloading }" />
            {{ isReloading ? 'Обновление...' : 'Обновить страницу' }}
          </button>
          <RouterLink to="/" class="btn btn-large btn-secondary" v-if="isOnline">
            <Home :size="20" />
            На главную
          </RouterLink>
        </div>
        <div class="offline-tips">
          <h3>Что можно сделать:</h3>
          <ul>
            <li>Проверьте подключение к Wi-Fi или мобильной сети</li>
            <li>Убедитесь, что интернет работает на других устройствах</li>
            <li>Попробуйте перезагрузить роутер</li>
            <li>Проверьте настройки сети на вашем устройстве</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { WifiOff, RefreshCw, Home } from 'lucide-vue-next'

const router = useRouter()
const isOnline = ref(navigator.onLine)
const isReloading = ref(false)

const updateOnlineStatus = () => {
  isOnline.value = navigator.onLine
  if (isOnline.value && isReloading.value) {
    setTimeout(() => {
      window.location.reload()
    }, 500)
  }
}

const reloadPage = () => {
  if (isOnline.value) {
    isReloading.value = true
    setTimeout(() => {
      window.location.reload()
    }, 500)
  }
}

onMounted(() => {
  window.addEventListener('online', updateOnlineStatus)
  window.addEventListener('offline', updateOnlineStatus)
  
  // Автоматическая перезагрузка при восстановлении соединения
  if (!isOnline.value) {
    const checkInterval = setInterval(() => {
      if (navigator.onLine) {
        clearInterval(checkInterval)
        isOnline.value = true
        setTimeout(() => {
          window.location.reload()
        }, 1000)
      }
    }, 2000)
    
    onUnmounted(() => {
      clearInterval(checkInterval)
    })
  }
})

onUnmounted(() => {
  window.removeEventListener('online', updateOnlineStatus)
  window.removeEventListener('offline', updateOnlineStatus)
})
</script>

<style scoped>
.offline-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background: var(--dark);
  position: relative;
  overflow: hidden;
}

.offline-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
  z-index: 0;
}

.gradient-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.3;
  animation: float-orb 20s ease-in-out infinite;
}

.orb-1 {
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, rgba(239, 68, 68, 0.4) 0%, transparent 70%);
  top: 10%;
  left: 10%;
  animation-delay: 0s;
}

.orb-2 {
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, rgba(113, 59, 219, 0.3) 0%, transparent 70%);
  bottom: 15%;
  right: 15%;
  animation-delay: 7s;
}

.orb-3 {
  width: 350px;
  height: 350px;
  background: radial-gradient(circle, rgba(0, 91, 255, 0.25) 0%, transparent 70%);
  top: 50%;
  left: 50%;
  animation-delay: 14s;
}

@keyframes float-orb {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(50px, -50px) scale(1.1);
  }
  66% {
    transform: translate(-30px, 40px) scale(0.9);
  }
}

.offline-content {
  position: relative;
  z-index: 1;
  text-align: center;
  max-width: 600px;
  margin: 0 auto;
}

.offline-icon {
  position: relative;
  display: inline-block;
  margin-bottom: 2rem;
  color: var(--accent-red);
}

.offline-icon svg {
  filter: drop-shadow(0 0 20px rgba(239, 68, 68, 0.5));
  animation: pulse-icon 2s ease-in-out infinite;
}

.icon-pulse {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 200px;
  height: 200px;
  border: 2px solid rgba(239, 68, 68, 0.3);
  border-radius: 50%;
  animation: pulse-ring 2s ease-out infinite;
}

@keyframes pulse-icon {
  0%, 100% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.1);
    opacity: 0.8;
  }
}

@keyframes pulse-ring {
  0% {
    transform: translate(-50%, -50%) scale(0.8);
    opacity: 1;
  }
  100% {
    transform: translate(-50%, -50%) scale(1.5);
    opacity: 0;
  }
}

.offline-title {
  font-size: 2.5rem;
  font-weight: 700;
  margin-bottom: 1rem;
  background: linear-gradient(135deg, #ef4444 0%, #f87171 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.offline-description {
  font-size: 1.125rem;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 2rem;
  line-height: 1.6;
}

.offline-status {
  margin-bottom: 2.5rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.status-item {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  color: rgba(255, 255, 255, 0.8);
}

.status-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: var(--accent-red);
  box-shadow: 0 0 10px rgba(239, 68, 68, 0.5);
  animation: pulse-dot 2s ease-in-out infinite;
}

.status-dot.online {
  background: #10b981;
  box-shadow: 0 0 10px rgba(16, 185, 129, 0.5);
  animation: none;
}

@keyframes pulse-dot {
  0%, 100% {
    opacity: 1;
    transform: scale(1);
  }
  50% {
    opacity: 0.5;
    transform: scale(1.2);
  }
}

.offline-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  margin-bottom: 3rem;
  flex-wrap: wrap;
}

.offline-actions .btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.spinning {
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

.offline-tips {
  padding-top: 2rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  text-align: left;
}

.offline-tips h3 {
  font-size: 1.25rem;
  margin-bottom: 1rem;
  color: var(--white);
}

.offline-tips ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.offline-tips li {
  padding: 0.5rem 0;
  padding-left: 1.5rem;
  color: rgba(255, 255, 255, 0.7);
  position: relative;
}

.offline-tips li::before {
  content: '→';
  position: absolute;
  left: 0;
  color: var(--primary);
  font-weight: 600;
}

@media (max-width: 768px) {
  .offline-title {
    font-size: 1.75rem;
  }

  .offline-description {
    font-size: 1rem;
  }

  .offline-actions {
    flex-direction: column;
  }

  .offline-actions .btn {
    width: 100%;
  }
}
</style>

