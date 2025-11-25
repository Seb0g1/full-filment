<template>
  <canvas 
    ref="canvasRef" 
    class="particle-canvas"
  ></canvas>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const canvasRef = ref(null)
let animationId = null
let particles = []
let resizeHandler = null

const createParticle = (canvas) => {
  const colors = [
    { r: 113, g: 59, b: 219 }, // purple
    { r: 203, g: 17, b: 171 },  // pink
    { r: 0, g: 91, b: 255 },    // blue
    { r: 99, g: 102, b: 241 }   // indigo
  ]
  const color = colors[Math.floor(Math.random() * colors.length)]
  
  return {
    x: Math.random() * canvas.width,
    y: Math.random() * canvas.height,
    radius: Math.random() * 3 + 1,
    vx: (Math.random() - 0.5) * 0.8,
    vy: (Math.random() - 0.5) * 0.8,
    opacity: Math.random() * 0.6 + 0.3,
    color: color,
    pulseSpeed: Math.random() * 0.02 + 0.01,
    pulsePhase: Math.random() * Math.PI * 2
  }
}

const initParticles = (canvas) => {
  const particleCount = Math.min(80, Math.floor((canvas.width * canvas.height) / 12000))
  particles = []
  for (let i = 0; i < particleCount; i++) {
    particles.push(createParticle(canvas))
  }
}

let time = 0

const drawParticles = (ctx, canvas) => {
  time += 0.01
  ctx.clearRect(0, 0, canvas.width, canvas.height)
  
  // Рисуем градиентные орбы
  const orb1 = {
    x: canvas.width * 0.2 + Math.sin(time * 0.5) * 100,
    y: canvas.height * 0.3 + Math.cos(time * 0.3) * 80,
    radius: 200 + Math.sin(time) * 50
  }
  const orb2 = {
    x: canvas.width * 0.8 + Math.cos(time * 0.4) * 120,
    y: canvas.height * 0.7 + Math.sin(time * 0.6) * 90,
    radius: 180 + Math.cos(time * 1.2) * 40
  }
  
  // Градиентный орб 1
  const gradient1 = ctx.createRadialGradient(orb1.x, orb1.y, 0, orb1.x, orb1.y, orb1.radius)
  gradient1.addColorStop(0, 'rgba(113, 59, 219, 0.15)')
  gradient1.addColorStop(0.5, 'rgba(203, 17, 171, 0.08)')
  gradient1.addColorStop(1, 'transparent')
  ctx.fillStyle = gradient1
  ctx.fillRect(0, 0, canvas.width, canvas.height)
  
  // Градиентный орб 2
  const gradient2 = ctx.createRadialGradient(orb2.x, orb2.y, 0, orb2.x, orb2.y, orb2.radius)
  gradient2.addColorStop(0, 'rgba(0, 91, 255, 0.12)')
  gradient2.addColorStop(0.5, 'rgba(99, 102, 241, 0.06)')
  gradient2.addColorStop(1, 'transparent')
  ctx.fillStyle = gradient2
  ctx.fillRect(0, 0, canvas.width, canvas.height)
  
  // Рисуем частицы
  particles.forEach((particle, i) => {
    // Обновляем пульсацию
    particle.pulsePhase += particle.pulseSpeed
    const pulse = Math.sin(particle.pulsePhase) * 0.3 + 1
    
    // Обновляем позицию
    particle.x += particle.vx
    particle.y += particle.vy
    
    // Отскок от краев
    if (particle.x < 0 || particle.x > canvas.width) particle.vx *= -1
    if (particle.y < 0 || particle.y > canvas.height) particle.vy *= -1
    
    // Рисуем частицу с градиентом
    const particleGradient = ctx.createRadialGradient(
      particle.x, particle.y, 0,
      particle.x, particle.y, particle.radius * pulse
    )
    particleGradient.addColorStop(0, `rgba(${particle.color.r}, ${particle.color.g}, ${particle.color.b}, ${particle.opacity})`)
    particleGradient.addColorStop(0.5, `rgba(${particle.color.r}, ${particle.color.g}, ${particle.color.b}, ${particle.opacity * 0.5})`)
    particleGradient.addColorStop(1, 'transparent')
    
    ctx.beginPath()
    ctx.arc(particle.x, particle.y, particle.radius * pulse, 0, Math.PI * 2)
    ctx.fillStyle = particleGradient
    ctx.fill()
    
    // Свечение вокруг частицы
    ctx.shadowBlur = 15
    ctx.shadowColor = `rgba(${particle.color.r}, ${particle.color.g}, ${particle.color.b}, 0.5)`
    ctx.fill()
    ctx.shadowBlur = 0
    
    // Соединения между частицами
    particles.forEach((otherParticle, j) => {
      if (i !== j && j > i) {
        const dx = particle.x - otherParticle.x
        const dy = particle.y - otherParticle.y
        const distance = Math.sqrt(dx * dx + dy * dy)
        
        if (distance < 180) {
          const opacity = 0.2 * (1 - distance / 180)
          const midX = (particle.x + otherParticle.x) / 2
          const midY = (particle.y + otherParticle.y) / 2
          
          // Градиент для линии
          const lineGradient = ctx.createLinearGradient(
            particle.x, particle.y,
            otherParticle.x, otherParticle.y
          )
          lineGradient.addColorStop(0, `rgba(${particle.color.r}, ${particle.color.g}, ${particle.color.b}, ${opacity})`)
          lineGradient.addColorStop(1, `rgba(${otherParticle.color.r}, ${otherParticle.color.g}, ${otherParticle.color.b}, ${opacity})`)
          
          ctx.beginPath()
          ctx.moveTo(particle.x, particle.y)
          ctx.lineTo(otherParticle.x, otherParticle.y)
          ctx.strokeStyle = lineGradient
          ctx.lineWidth = 1.5
          ctx.stroke()
        }
      }
    })
  })
  
  animationId = requestAnimationFrame(() => drawParticles(ctx, canvas))
}

onMounted(() => {
  if (!canvasRef.value) return
  
  const canvas = canvasRef.value
  const ctx = canvas.getContext('2d')
  
  const resizeCanvas = () => {
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    initParticles(canvas)
  }
  
  resizeCanvas()
  resizeHandler = resizeCanvas
  window.addEventListener('resize', resizeHandler)
  
  drawParticles(ctx, canvas)
})

onUnmounted(() => {
  if (resizeHandler) {
    window.removeEventListener('resize', resizeHandler)
  }
  if (animationId) {
    cancelAnimationFrame(animationId)
  }
})
</script>

<style scoped>
.particle-canvas {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  pointer-events: none;
  opacity: 0.5;
}
</style>
