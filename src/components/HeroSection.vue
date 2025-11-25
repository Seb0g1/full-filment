<template>
  <section class="hero section">
    <div class="hero-background">
      <div class="gradient-orb orb-1"></div>
      <div class="gradient-orb orb-2"></div>
      <div class="gradient-orb orb-3"></div>
    </div>
    <div class="container">
      <div class="hero-content fade-in-section">
        <div class="hero-badge">
          <Zap :size="20" class="badge-icon" />
          <span>Фулфилмент в Москве от 25 руб/заказ</span>
        </div>
        <h1 class="hero-title">
          Заберем.<br>
          Упакуем.<br>
          Промаркируем.<br>
          Доставим.
        </h1>
        <p class="hero-subtitle">
          на склад <span class="gradient-text">маркетплейса</span><br>
          за <span class="highlight">24 часа!</span>
        </p>
        <div class="hero-actions">
          <a href="#calculator" class="btn btn-large glow">
            Узнать цену
          </a>
          <a href="#contacts" class="btn btn-large btn-secondary">
            Получить консультацию
          </a>
        </div>
        <div class="hero-stats">
          <div class="stat-item">
            <div class="stat-number" ref="stat1Ref">24</div>
            <div class="stat-label">часа</div>
          </div>
          <div class="stat-item">
            <div class="stat-number" ref="stat2Ref">1000+</div>
            <div class="stat-label">клиентов</div>
          </div>
          <div class="stat-item">
            <div class="stat-number" ref="stat3Ref">99%</div>
            <div class="stat-label">точность</div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { gsap } from 'gsap'
import { Zap } from 'lucide-vue-next'

const stat1Ref = ref(null)
const stat2Ref = ref(null)
const stat3Ref = ref(null)

onMounted(() => {
  // Анимация чисел
  const animateNumber = (element, endValue, duration = 2) => {
    if (!element) return
    const suffix = endValue.toString().includes('+') ? '+' : endValue.toString().includes('%') ? '%' : ''
    const numValue = parseInt(endValue) || 0
    
    const obj = { value: 0 }
    gsap.to(obj, {
      value: numValue,
      duration: duration,
      snap: { value: 1 },
      ease: "power2.out",
      onUpdate: () => {
        if (element) {
          element.innerText = Math.floor(obj.value) + suffix
        }
      }
    })
  }

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateNumber(stat1Ref.value, 24)
        animateNumber(stat2Ref.value, '1000+')
        animateNumber(stat3Ref.value, '99%')
        observer.disconnect()
      }
    })
  }, { threshold: 0.5 })

  setTimeout(() => {
    const statsContainer = document.querySelector('.hero-stats')
    if (statsContainer) observer.observe(statsContainer)
  }, 500)
})
</script>

<style scoped>
.hero {
  min-height: 100vh;
  display: flex;
  align-items: center;
  position: relative;
  overflow: hidden;
  padding-top: 80px;
}

.hero-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow: hidden;
  z-index: 0;
}

.hero-background::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 800px;
  height: 800px;
  background: radial-gradient(circle, rgba(113, 59, 219, 0.2) 0%, transparent 70%);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  animation: pulse-orb 8s ease-in-out infinite;
  filter: blur(100px);
}

.hero-background::after {
  content: '';
  position: absolute;
  top: 20%;
  right: 10%;
  width: 600px;
  height: 600px;
  background: radial-gradient(circle, rgba(0, 91, 255, 0.15) 0%, transparent 70%);
  border-radius: 50%;
  animation: float-orb 12s ease-in-out infinite;
  filter: blur(80px);
}

@keyframes pulse-orb {
  0%, 100% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.6;
  }
  50% {
    transform: translate(-50%, -50%) scale(1.2);
    opacity: 0.8;
  }
}

@keyframes float-orb {
  0%, 100% {
    transform: translate(0, 0);
  }
  33% {
    transform: translate(50px, -50px);
  }
  66% {
    transform: translate(-50px, 50px);
  }
}

.gradient-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.5;
  animation: float 20s ease-in-out infinite;
}

.orb-1 {
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, rgba(113, 59, 219, 0.4) 0%, rgba(203, 17, 171, 0.3) 100%);
  top: -200px;
  left: -200px;
  animation-delay: 0s;
  box-shadow: 0 0 100px rgba(113, 59, 219, 0.5);
}

.orb-2 {
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, rgba(0, 91, 255, 0.4) 0%, rgba(249, 17, 85, 0.3) 100%);
  bottom: -150px;
  right: -150px;
  animation-delay: -7s;
  box-shadow: 0 0 80px rgba(0, 91, 255, 0.5);
}

.orb-3 {
  width: 300px;
  height: 300px;
  background: radial-gradient(circle, rgba(203, 17, 171, 0.4) 0%, rgba(255, 221, 0, 0.2) 100%);
  top: 50%;
  right: 10%;
  animation-delay: -14s;
  box-shadow: 0 0 60px rgba(203, 17, 171, 0.5);
}

@keyframes float {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(50px, -50px) scale(1.1);
  }
  66% {
    transform: translate(-50px, 50px) scale(0.9);
  }
}

.hero-content {
  position: relative;
  z-index: 1;
  max-width: 800px;
}

.hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  background: rgba(113, 59, 219, 0.1);
  border: 1px solid rgba(113, 59, 219, 0.2);
  border-radius: 8px;
  margin-bottom: 2rem;
  font-weight: 500;
  font-size: 0.9375rem;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.hero-badge:hover {
  background: rgba(113, 59, 219, 0.15);
  border-color: rgba(113, 59, 219, 0.3);
}

.badge-icon {
  color: var(--primary);
  opacity: 0.8;
  flex-shrink: 0;
}

.hero-title {
  margin-bottom: 1.5rem;
  line-height: 1.1;
}

.hero-subtitle {
  font-size: clamp(1.5rem, 3vw, 2.5rem);
  margin-bottom: 2.5rem;
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.4;
}

.highlight {
  color: var(--accent);
  font-weight: 700;
}

.hero-actions {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
  margin-bottom: 4rem;
}

.hero-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
  padding: 2rem;
  background: rgba(255, 255, 255, 0.02);
  backdrop-filter: blur(20px) saturate(150%);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.06);
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.hero-stats:hover {
  background: rgba(255, 255, 255, 0.04);
  border-color: rgba(113, 59, 219, 0.2);
}

.stat-item {
  text-align: center;
}

.stat-number {
  font-size: 3rem;
  font-weight: 700;
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 0.5rem;
  transition: all 0.3s ease;
}

.stat-item:hover .stat-number {
  transform: scale(1.05);
}

.stat-label {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.875rem;
  text-transform: uppercase;
  letter-spacing: 1px;
}

@media (max-width: 768px) {
  .hero {
    padding-top: 100px;
  }

  .hero-actions {
    flex-direction: column;
  }

  .hero-stats {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
}
</style>
