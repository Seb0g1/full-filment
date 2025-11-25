<template>
  <div ref="container" class="logistics-3d"></div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import * as THREE from 'three'

const container = ref(null)
let scene, camera, renderer, animationId
let trucks = []
let boxes = []

const init3D = () => {
  if (!container.value) return

  // Сцена
  scene = new THREE.Scene()
  scene.fog = new THREE.FogExp2(0x0a0a14, 0.0008)

  // Камера
  camera = new THREE.PerspectiveCamera(
    50,
    window.innerWidth / window.innerHeight,
    0.1,
    2000
  )
  camera.position.set(0, 5, 15)
  camera.lookAt(0, 0, 0)

  // Рендерер
  renderer = new THREE.WebGLRenderer({ 
    alpha: true, 
    antialias: true,
    powerPreference: "high-performance"
  })
  renderer.setSize(window.innerWidth, window.innerHeight)
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
  renderer.setClearColor(0x000000, 0)
  container.value.appendChild(renderer.domElement)

  // Освещение
  const ambientLight = new THREE.AmbientLight(0xffffff, 0.4)
  scene.add(ambientLight)

  const directionalLight1 = new THREE.DirectionalLight(0x713bdb, 0.6)
  directionalLight1.position.set(5, 10, 5)
  scene.add(directionalLight1)

  const directionalLight2 = new THREE.DirectionalLight(0x005BFF, 0.4)
  directionalLight2.position.set(-5, 5, -5)
  scene.add(directionalLight2)

  // Создаем грузовики
  for (let i = 0; i < 3; i++) {
    const truck = createTruck()
    truck.position.x = (i - 1) * 8
    truck.position.z = -i * 5
    truck.position.y = 0.5
    truck.rotation.y = Math.PI / 2
    scene.add(truck)
    trucks.push(truck)
  }

  // Создаем ящики/коробки
  for (let i = 0; i < 8; i++) {
    const box = createBox()
    const angle = (i / 8) * Math.PI * 2
    const radius = 8 + Math.random() * 3
    box.position.x = Math.cos(angle) * radius
    box.position.z = Math.sin(angle) * radius
    box.position.y = 0.5
    box.rotation.y = Math.random() * Math.PI * 2
    scene.add(box)
    boxes.push(box)
  }

  // Создаем складские элементы
  createWarehouseElements()

  // Анимация
  lastTime = performance.now()
  animate(lastTime)

  // Обработка изменения размера
  window.addEventListener('resize', onWindowResize)
}

const createTruck = () => {
  const group = new THREE.Group()

  // Кабина
  const cabinGeometry = new THREE.BoxGeometry(2, 1.5, 1.5)
  const cabinMaterial = new THREE.MeshPhongMaterial({ 
    color: 0x4a5568,
    emissive: 0x000000,
    specular: 0x222222
  })
  const cabin = new THREE.Mesh(cabinGeometry, cabinMaterial)
  cabin.position.set(0, 0.75, 0)
  group.add(cabin)

  // Кузов
  const bodyGeometry = new THREE.BoxGeometry(3, 1.2, 1.5)
  const bodyMaterial = new THREE.MeshPhongMaterial({ 
    color: 0x2d3748,
    emissive: 0x1a202c,
    specular: 0x333333
  })
  const body = new THREE.Mesh(bodyGeometry, bodyMaterial)
  body.position.set(-1.5, 0.6, 0)
  group.add(body)

  // Колеса
  const wheelGeometry = new THREE.CylinderGeometry(0.4, 0.4, 0.3, 16)
  const wheelMaterial = new THREE.MeshPhongMaterial({ 
    color: 0x1a1a1a,
    emissive: 0x000000
  })

  const positions = [
    [1, 0.4, 0.8],
    [1, 0.4, -0.8],
    [-2, 0.4, 0.8],
    [-2, 0.4, -0.8]
  ]

  positions.forEach(pos => {
    const wheel = new THREE.Mesh(wheelGeometry, wheelMaterial)
    wheel.rotation.z = Math.PI / 2
    wheel.position.set(pos[0], pos[1], pos[2])
    group.add(wheel)
  })

  // Фары
  const lightGeometry = new THREE.SphereGeometry(0.15, 8, 8)
  const lightMaterial = new THREE.MeshBasicMaterial({ 
    color: 0x005BFF,
    emissive: 0x005BFF,
    emissiveIntensity: 0.5
  })
  
  const leftLight = new THREE.Mesh(lightGeometry, lightMaterial)
  leftLight.position.set(1.2, 0.5, 0.5)
  group.add(leftLight)

  const rightLight = new THREE.Mesh(lightGeometry, lightMaterial)
  rightLight.position.set(1.2, 0.5, -0.5)
  group.add(rightLight)

  return group
}

const createBox = () => {
  const size = 0.6 + Math.random() * 0.4
  const geometry = new THREE.BoxGeometry(size, size, size)
  const material = new THREE.MeshPhongMaterial({ 
    color: new THREE.Color().setHSL(0.7 + Math.random() * 0.1, 0.5, 0.4),
    emissive: new THREE.Color().setHSL(0.7 + Math.random() * 0.1, 0.3, 0.1),
    specular: 0x222222
  })
  const box = new THREE.Mesh(geometry, material)
  return box
}

const createWarehouseElements = () => {
  // Паллеты
  for (let i = 0; i < 6; i++) {
    const pallet = createPallet()
    pallet.position.x = -10 + (i % 3) * 3
    pallet.position.z = -10 + Math.floor(i / 3) * 3
    pallet.position.y = 0.25
    scene.add(pallet)
  }

  // Полки/стеллажи
  const rackGeometry = new THREE.BoxGeometry(0.2, 4, 2)
  const rackMaterial = new THREE.MeshPhongMaterial({ 
    color: 0x4a5568,
    emissive: 0x1a202c
  })

  for (let i = 0; i < 4; i++) {
    const rack = new THREE.Mesh(rackGeometry, rackMaterial)
    rack.position.set(-12 + i * 2, 2, -10)
    scene.add(rack)
  }
}

const createPallet = () => {
  const group = new THREE.Group()
  
  // Основание
  const baseGeometry = new THREE.BoxGeometry(1.2, 0.1, 1.2)
  const baseMaterial = new THREE.MeshPhongMaterial({ 
    color: 0x8b6914,
    emissive: 0x000000
  })
  const base = new THREE.Mesh(baseGeometry, baseMaterial)
  group.add(base)

  // Ножки
  const legGeometry = new THREE.BoxGeometry(0.08, 0.15, 0.08)
  const legMaterial = new THREE.MeshPhongMaterial({ color: 0x654321 })
  
  const legPositions = [
    [-0.5, 0.15, -0.5],
    [0.5, 0.15, -0.5],
    [-0.5, 0.15, 0.5],
    [0.5, 0.15, 0.5]
  ]

  legPositions.forEach(pos => {
    const leg = new THREE.Mesh(legGeometry, legMaterial)
    leg.position.set(pos[0], pos[1], pos[2])
    group.add(leg)
  })

  return group
}

let lastTime = 0
const animate = (currentTime) => {
  animationId = requestAnimationFrame(animate)

  // Ограничение FPS для производительности
  const delta = currentTime - lastTime
  if (delta < 33) return // ~30 FPS
  lastTime = currentTime

  const time = currentTime * 0.0001

  // Анимация грузовиков
  trucks.forEach((truck, index) => {
    truck.position.z += 0.008
    if (truck.position.z > 10) {
      truck.position.z = -15
    }
    
    // Небольшое покачивание
    truck.rotation.y = Math.PI / 2 + Math.sin(time * 10 + index) * 0.03
    truck.position.y = 0.5 + Math.sin(time * 20 + index) * 0.08
  })

  // Медленное вращение ящиков
  boxes.forEach((box, index) => {
    box.rotation.y += 0.001 + index * 0.00005
    box.position.y = 0.5 + Math.sin(time * 10 + index) * 0.08
  })

  // Медленное вращение камеры
  camera.position.x = Math.cos(time * 3) * 1.5
  camera.position.z = 15 + Math.sin(time * 2) * 0.8
  camera.position.y = 5 + Math.sin(time * 1.5) * 0.5
  camera.lookAt(0, 0, 0)

  renderer.render(scene, camera)
}

const onWindowResize = () => {
  if (!camera || !renderer) return
  
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize(window.innerWidth, window.innerHeight)
}

const cleanup = () => {
  window.removeEventListener('resize', onWindowResize)
  
  if (animationId) {
    cancelAnimationFrame(animationId)
  }

  if (renderer && container.value) {
    renderer.dispose()
    if (renderer.domElement && container.value.contains(renderer.domElement)) {
      container.value.removeChild(renderer.domElement)
    }
  }

  // Очистка геометрий и материалов
  if (scene) {
    scene.traverse((object) => {
      if (object instanceof THREE.Mesh) {
        if (object.geometry) {
          object.geometry.dispose()
        }
        if (object.material) {
          if (Array.isArray(object.material)) {
            object.material.forEach(material => material.dispose())
          } else {
            object.material.dispose()
          }
        }
      }
    })
  }
}

onMounted(() => {
  init3D()
})

onBeforeUnmount(() => {
  cleanup()
})
</script>

<style scoped>
.logistics-3d {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 0;
  opacity: 0.1;
  mix-blend-mode: normal;
}

.logistics-3d canvas {
  display: block;
  width: 100%;
  height: 100%;
  image-rendering: -webkit-optimize-contrast;
  image-rendering: crisp-edges;
}

@media (max-width: 968px) {
  .logistics-3d {
    opacity: 0.2;
  }
}

@media (max-width: 768px) {
  .logistics-3d {
    opacity: 0.15;
  }
}

@media (prefers-reduced-motion: reduce) {
  .logistics-3d {
    opacity: 0.1;
    animation: none;
  }
}
</style>
