<template>
  <div class="not-found-page">
    <div class="not-found-background">
      <div class="gradient-orb orb-1"></div>
      <div class="gradient-orb orb-2"></div>
      <div class="gradient-orb orb-3"></div>
    </div>
    <div class="container">
      <div class="not-found-content">
        <div class="error-code">
          <span class="code-number">4</span>
          <span class="code-icon">
            <Package :size="120" />
          </span>
          <span class="code-number">4</span>
        </div>
        <h1 class="error-title">Страница не найдена</h1>
        <p class="error-description">
          К сожалению, страница, которую вы ищете, не существует или была перемещена.
        </p>
        <div class="error-actions">
          <RouterLink to="/" class="btn btn-large">
            <Home :size="20" />
            Вернуться на главную
          </RouterLink>
          <button @click="goBack" class="btn btn-large btn-secondary">
            <ArrowLeft :size="20" />
            Назад
          </button>
        </div>
        <div class="quick-links">
          <p>Или перейдите к:</p>
          <div class="links-grid">
            <RouterLink to="/#services" class="quick-link">Услуги</RouterLink>
            <RouterLink to="/#tariffs" class="quick-link">Тарифы</RouterLink>
            <RouterLink to="/#calculator" class="quick-link">Калькулятор</RouterLink>
            <RouterLink to="/#contacts" class="quick-link">Контакты</RouterLink>
            <RouterLink to="/#faq" class="quick-link">FAQ</RouterLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { Home, ArrowLeft, Package } from 'lucide-vue-next'

const router = useRouter()

const goBack = () => {
  if (window.history.length > 1) {
    router.go(-1)
  } else {
    router.push('/')
  }
}
</script>

<style scoped>
.not-found-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background: var(--dark);
  position: relative;
  overflow: hidden;
}

.not-found-background {
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
  background: radial-gradient(circle, rgba(113, 59, 219, 0.4) 0%, transparent 70%);
  top: 10%;
  left: 10%;
  animation-delay: 0s;
}

.orb-2 {
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, rgba(0, 91, 255, 0.3) 0%, transparent 70%);
  bottom: 15%;
  right: 15%;
  animation-delay: 7s;
}

.orb-3 {
  width: 350px;
  height: 350px;
  background: radial-gradient(circle, rgba(203, 17, 171, 0.25) 0%, transparent 70%);
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

.not-found-content {
  position: relative;
  z-index: 1;
  text-align: center;
  max-width: 700px;
  margin: 0 auto;
}

.error-code {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  margin-bottom: 2rem;
  font-size: 8rem;
  font-weight: 800;
  line-height: 1;
}

.code-number {
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: pulse-glow 2s ease-in-out infinite;
}

.code-icon {
  color: var(--primary);
  opacity: 0.8;
  animation: float-icon 3s ease-in-out infinite;
}

@keyframes pulse-glow {
  0%, 100% {
    filter: drop-shadow(0 0 20px rgba(113, 59, 219, 0.5));
  }
  50% {
    filter: drop-shadow(0 0 40px rgba(113, 59, 219, 0.8));
  }
}

@keyframes float-icon {
  0%, 100% {
    transform: translateY(0) rotate(0deg);
  }
  50% {
    transform: translateY(-20px) rotate(10deg);
  }
}

.error-title {
  font-size: 2.5rem;
  font-weight: 700;
  margin-bottom: 1rem;
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.error-description {
  font-size: 1.125rem;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 2.5rem;
  line-height: 1.6;
}

.error-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  margin-bottom: 3rem;
  flex-wrap: wrap;
}

.error-actions .btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.quick-links {
  padding-top: 2rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.quick-links p {
  color: rgba(255, 255, 255, 0.6);
  margin-bottom: 1rem;
  font-size: 0.9375rem;
}

.links-grid {
  display: flex;
  gap: 0.75rem;
  justify-content: center;
  flex-wrap: wrap;
}

.quick-link {
  padding: 0.625rem 1.25rem;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  font-size: 0.9375rem;
  font-weight: 500;
  transition: all 0.3s ease;
}

.quick-link:hover {
  background: rgba(113, 59, 219, 0.1);
  border-color: var(--primary);
  color: var(--primary-light);
  transform: translateY(-2px);
}

@media (max-width: 768px) {
  .error-code {
    font-size: 5rem;
    gap: 0.5rem;
  }

  .code-icon {
    transform: scale(0.7);
  }

  .error-title {
    font-size: 1.75rem;
  }

  .error-description {
    font-size: 1rem;
  }

  .error-actions {
    flex-direction: column;
  }

  .error-actions .btn {
    width: 100%;
  }
}
</style>

