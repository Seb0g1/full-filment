<script setup>
import { onMounted } from 'vue'

onMounted(() => {
  // Плавная прокрутка к якорям
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const href = this.getAttribute('href')
      if (href === '#' || !href) return
      
      const target = document.querySelector(href)
      if (target) {
        e.preventDefault()
        const headerOffset = 80
        const elementPosition = target.getBoundingClientRect().top
        const offsetPosition = elementPosition + window.pageYOffset - headerOffset

        window.scrollTo({
          top: offsetPosition,
          behavior: 'smooth'
        })
      }
    })
  })
})
</script>

<template>
  <!-- Компонент без визуального содержимого -->
</template>

