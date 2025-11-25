<template>
  <header class="header glass" :class="{ scrolled: isScrolled }">
    <div class="container">
      <nav class="nav">
        <a href="/" class="logo">
          <img src="/logo.svg" alt="Sakoo Фулфилмент" class="logo-img" />
          <span class="logo-text">Sakoo</span>
          <span class="logo-badge">Фулфилмент</span>
        </a>
        <div class="nav-links" :class="{ active: menuOpen }">
          <a href="#services" @click="closeMenu" :class="{ active: activeSection === 'services' }">Услуги</a>
          <a href="#tariffs" @click="closeMenu" :class="{ active: activeSection === 'tariffs' }">Тарифы</a>
          <a href="#calculator" @click="closeMenu" :class="{ active: activeSection === 'calculator' }">Расчет</a>
          <a href="#contacts" @click="closeMenu" :class="{ active: activeSection === 'contacts' }">Контакты</a>
          <a href="#faq" @click="closeMenu" :class="{ active: activeSection === 'faq' }">FAQ</a>
        </div>
        <div class="nav-actions">
          <a href="tel:+79099059949" class="phone-btn">
            <span>+7 (909) 905-99-49</span>
          </a>
          <button class="menu-toggle" @click="toggleMenu" aria-label="Меню">
            <span></span>
            <span></span>
            <span></span>
          </button>
        </div>
      </nav>
    </div>
  </header>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const isScrolled = ref(false)
const menuOpen = ref(false)
const activeSection = ref('')

const handleScroll = () => {
  isScrolled.value = window.scrollY > 50
  
  // Определяем активную секцию
  const sections = ['services', 'tariffs', 'calculator', 'contacts', 'faq']
  const scrollPosition = window.scrollY + 150
  
  for (let i = sections.length - 1; i >= 0; i--) {
    const section = document.getElementById(sections[i])
    if (section && section.offsetTop <= scrollPosition) {
      activeSection.value = sections[i]
      break
    }
  }
}

const toggleMenu = () => {
  menuOpen.value = !menuOpen.value
}

const closeMenu = () => {
  menuOpen.value = false
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
.header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  padding: 1.25rem 0;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  background: rgba(10, 10, 20, 0.75);
  backdrop-filter: blur(30px) saturate(180%);
  -webkit-backdrop-filter: blur(30px) saturate(180%);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.header.scrolled {
  padding: 0.875rem 0;
  background: rgba(10, 10, 20, 0.9);
  backdrop-filter: blur(40px) saturate(180%);
  -webkit-backdrop-filter: blur(40px) saturate(180%);
  box-shadow: 
    0 8px 32px rgba(0, 0, 0, 0.2),
    0 0 0 1px rgba(113, 59, 219, 0.15);
  border-bottom-color: rgba(113, 59, 219, 0.3);
}

.nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
}

.logo {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--white);
  text-decoration: none;
  transition: opacity 0.3s ease;
}

.logo:hover {
  opacity: 0.8;
}

.logo-img {
  height: 40px;
  width: auto;
  display: block;
  flex-shrink: 0;
}

.logo-text {
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.logo-badge {
  font-size: 0.75rem;
  padding: 0.25rem 0.75rem;
  background: var(--gradient-accent);
  border-radius: 20px;
  font-weight: 600;
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 2rem;
  flex: 1;
  justify-content: center;
}

.nav-links a {
  color: var(--white);
  text-decoration: none;
  font-weight: 500;
  position: relative;
  transition: color 0.3s ease;
  padding: 0.5rem 0;
}

.nav-links a::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 0;
  height: 2px;
  background: var(--gradient-primary);
  transition: width 0.3s ease;
}

.nav-links a:hover {
  color: var(--primary-light);
}

.nav-links a:hover::after {
  width: 100%;
}

.nav-links a.active {
  color: var(--primary-light);
}

.nav-links a.active::after {
  width: 100%;
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.phone-btn {
  display: flex;
  align-items: center;
  padding: 0.875rem 1.75rem;
  background: var(--gradient-primary);
  border-radius: 12px;
  color: var(--white);
  text-decoration: none;
  font-weight: 600;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: var(--shadow-primary);
  position: relative;
  overflow: hidden;
}

.phone-btn::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  transform: translate(-50%, -50%);
  transition: width 0.6s, height 0.6s;
}

.phone-btn:hover::before {
  width: 300px;
  height: 300px;
}

.phone-btn:hover {
  transform: translateY(-3px) scale(1.05);
  box-shadow: var(--shadow-glow);
}

.phone-btn span {
  position: relative;
  z-index: 1;
}

.menu-toggle {
  display: none;
  flex-direction: column;
  gap: 5px;
  background: transparent;
  border: none;
  cursor: pointer;
  padding: 0.5rem;
}

.menu-toggle span {
  width: 25px;
  height: 3px;
  background: var(--white);
  border-radius: 3px;
  transition: all 0.3s ease;
}

@media (max-width: 968px) {
  .logo-img {
    height: 32px;
  }

  .logo {
    font-size: 1.25rem;
    gap: 0.5rem;
  }

  .nav-links {
    position: fixed;
    top: 70px;
    left: 0;
    right: 0;
    background: rgba(15, 23, 42, 0.95);
    backdrop-filter: blur(20px);
    flex-direction: column;
    padding: 2rem;
    transform: translateX(-100%);
    transition: transform 0.3s ease;
  }

  .nav-links.active {
    transform: translateX(0);
  }

  .menu-toggle {
    display: flex;
  }

  .phone-btn {
    display: none;
  }
}
</style>
