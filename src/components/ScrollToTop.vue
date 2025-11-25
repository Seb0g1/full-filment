<template>
  <button
    v-if="isVisible"
    @click="scrollToTop"
    class="scroll-to-top glass"
    aria-label="Наверх"
  >
    <ArrowUp :size="24" />
  </button>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { ArrowUp } from 'lucide-vue-next'

const isVisible = ref(false)

const handleScroll = () => {
  isVisible.value = window.scrollY > 300
}

const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
  handleScroll()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
.scroll-to-top {
  position: fixed;
  bottom: 6rem;
  right: 2rem;
  width: 56px;
  height: 56px;
  border-radius: 50%;
  border: none;
  background: var(--gradient-primary);
  color: var(--white);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: var(--shadow-lg);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  z-index: 9998;
  opacity: 0;
  transform: translateY(20px) scale(0.8);
  animation: fadeInUp 0.3s ease forwards;
}

.scroll-to-top:hover {
  transform: translateY(-4px) scale(1.05);
  box-shadow: var(--shadow-xl);
}

.scroll-to-top:active {
  transform: translateY(-2px) scale(1);
}

@keyframes fadeInUp {
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

@media (max-width: 768px) {
  .scroll-to-top {
    bottom: 5rem;
    right: 1rem;
    width: 48px;
    height: 48px;
  }
}
</style>

