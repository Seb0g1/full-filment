<template>
  <div class="speed-background">
    <!-- Улучшенные линии скорости -->
    <div class="speed-lines" v-for="i in 7" :key="i" :style="{ animationDelay: `${i * 0.4}s`, left: `${(i - 1) * 14.28}%` }"></div>
    
    <!-- Волны -->
    <div class="wave wave-1"></div>
    <div class="wave wave-2"></div>
    <div class="wave wave-3"></div>
    
    <!-- Улучшенные стрелки -->
    <div class="speed-arrows" v-for="i in 10" :key="'arrow-' + i" :style="{ animationDelay: `${i * 0.25}s`, left: `${(i - 1) * 10}%` }">
      <svg width="60" height="60" viewBox="0 0 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient :id="`arrowGradient-${i}`" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:#005BFF;stop-opacity:1" />
            <stop offset="50%" style="stop-color:#713BDB;stop-opacity:1" />
            <stop offset="100%" style="stop-color:#CB11AB;stop-opacity:1" />
          </linearGradient>
        </defs>
        <path d="M30 10L40 30L30 50L20 30L30 10Z" :fill="`url(#arrowGradient-${i})`" opacity="0.4">
          <animate attributeName="opacity" values="0.2;0.5;0.2" dur="2.5s" :begin="`${i * 0.25}s`" repeatCount="indefinite"/>
          <animateTransform attributeName="transform" type="rotate" values="0 30 30;360 30 30" dur="8s" :begin="`${i * 0.25}s`" repeatCount="indefinite"/>
        </path>
      </svg>
    </div>
    
    <!-- Улучшенные точки -->
    <div class="speed-dots" v-for="i in 15" :key="'dot-' + i" :style="{ animationDelay: `${i * 0.15}s`, left: `${(i - 1) * 6.66}%` }"></div>
    
    <!-- Плавающие градиентные круги -->
    <div class="floating-orb orb-1"></div>
    <div class="floating-orb orb-2"></div>
    <div class="floating-orb orb-3"></div>
  </div>
</template>

<script setup>
// Компонент с эффектами скорости и доставки
</script>

<style scoped>
.speed-background {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
  z-index: 0;
  overflow: hidden;
  opacity: 0.12;
}

.speed-lines {
  position: absolute;
  top: 0;
  width: 3px;
  height: 100%;
  background: linear-gradient(
    to bottom,
    transparent 0%,
    rgba(113, 59, 219, 0.4) 15%,
    rgba(0, 91, 255, 0.5) 30%,
    rgba(203, 17, 171, 0.5) 50%,
    rgba(0, 91, 255, 0.5) 70%,
    rgba(113, 59, 219, 0.4) 85%,
    transparent 100%
  );
  animation: speed-line-move 6s linear infinite;
  box-shadow: 
    0 0 15px rgba(113, 59, 219, 0.6),
    0 0 30px rgba(0, 91, 255, 0.4);
  filter: blur(0.5px);
}

@keyframes speed-line-move {
  0% {
    transform: translateY(-100%);
    opacity: 0;
  }
  10% {
    opacity: 1;
  }
  90% {
    opacity: 1;
  }
  100% {
    transform: translateY(100vh);
    opacity: 0;
  }
}

.speed-arrows {
  position: absolute;
  bottom: 0;
  width: 60px;
  height: 60px;
  animation: speed-arrow-up 10s linear infinite;
  filter: drop-shadow(0 0 12px rgba(113, 59, 219, 0.8));
}

@keyframes speed-arrow-up {
  0% {
    transform: translateY(0) rotate(-45deg);
    opacity: 0;
  }
  5% {
    opacity: 1;
  }
  95% {
    opacity: 1;
  }
  100% {
    transform: translateY(-100vh) rotate(-45deg);
    opacity: 0;
  }
}

.speed-dots {
  position: absolute;
  top: 0;
  width: 10px;
  height: 10px;
  background: radial-gradient(circle, rgba(99, 102, 241, 1) 0%, rgba(113, 59, 219, 0.6) 40%, transparent 70%);
  border-radius: 50%;
  animation: speed-dot-down 8s linear infinite;
  box-shadow: 
    0 0 20px rgba(99, 102, 241, 0.9),
    0 0 40px rgba(203, 17, 171, 0.5);
}

/* Волны */
.wave {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 200px;
  background: linear-gradient(
    to top,
    transparent,
    rgba(113, 59, 219, 0.1),
    transparent
  );
  border-radius: 50% 50% 0 0;
  animation: wave-animation 8s ease-in-out infinite;
}

.wave-1 {
  animation-delay: 0s;
  opacity: 0.6;
}

.wave-2 {
  animation-delay: 2s;
  opacity: 0.4;
  height: 150px;
}

.wave-3 {
  animation-delay: 4s;
  opacity: 0.3;
  height: 100px;
}

@keyframes wave-animation {
  0%, 100% {
    transform: translateX(0) scaleY(1);
  }
  50% {
    transform: translateX(-25px) scaleY(1.1);
  }
}

/* Плавающие градиентные орбы */
.floating-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(60px);
  animation: float-orb 20s ease-in-out infinite;
}

.orb-1 {
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, rgba(113, 59, 219, 0.3) 0%, transparent 70%);
  top: 10%;
  left: 10%;
  animation-delay: 0s;
}

.orb-2 {
  width: 350px;
  height: 350px;
  background: radial-gradient(circle, rgba(0, 91, 255, 0.25) 0%, transparent 70%);
  bottom: 15%;
  right: 15%;
  animation-delay: 7s;
}

.orb-3 {
  width: 300px;
  height: 300px;
  background: radial-gradient(circle, rgba(203, 17, 171, 0.2) 0%, transparent 70%);
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

@keyframes speed-dot-down {
  0% {
    transform: translateY(0) scale(0);
    opacity: 0;
  }
  10% {
    opacity: 1;
    transform: scale(1);
  }
  90% {
    opacity: 1;
    transform: scale(1);
  }
  100% {
    transform: translateY(100vh) scale(0);
    opacity: 0;
  }
}

@media (max-width: 768px) {
  .speed-background {
    opacity: 0.2;
  }
  
  .speed-arrows {
    width: 40px;
    height: 40px;
  }
}
</style>

