<script setup>
import { onMounted, onUnmounted } from 'vue'

onMounted(() => {
  const parallaxElements = document.querySelectorAll('[data-parallax]')
  
  const handleParallax = () => {
    const scrollTop = window.pageYOffset
    
    parallaxElements.forEach(element => {
      const speed = parseFloat(element.dataset.parallax) || 0.5
      const yPos = -(scrollTop * speed)
      element.style.transform = `translateY(${yPos}px)`
    })
  }
  
  window.addEventListener('scroll', handleParallax, { passive: true })
  
  onUnmounted(() => {
    window.removeEventListener('scroll', handleParallax)
  })
})
</script>

<template>
  <!-- Компонент без визуального содержимого -->
</template>

