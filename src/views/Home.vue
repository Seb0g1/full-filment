<template>
  <div>
    <Header />
    <main>
      <HeroSection />
      <MarketplacesSection />
      <AdvantagesSection />
      <ProcessSection />
      <PricingSection />
      <CalculatorSection />
      <FAQSection />
      <ContactSection />
    </main>
    <Footer />
    <Logistics3D />
    <ParticleBackground />
    <SpeedBackground />
    <ManagerChat />
    <ScrollToTop />
    <ReadingProgress />
    <SmoothScroll />
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import Header from '../components/Header.vue'
import HeroSection from '../components/HeroSection.vue'
import MarketplacesSection from '../components/MarketplacesSection.vue'
import AdvantagesSection from '../components/AdvantagesSection.vue'
import ProcessSection from '../components/ProcessSection.vue'
import PricingSection from '../components/PricingSection.vue'
import CalculatorSection from '../components/CalculatorSection.vue'
import FAQSection from '../components/FAQSection.vue'
import ContactSection from '../components/ContactSection.vue'
import Footer from '../components/Footer.vue'
import Logistics3D from '../components/Logistics3D.vue'
import ParticleBackground from '../components/ParticleBackground.vue'
import SpeedBackground from '../components/SpeedBackground.vue'
import ManagerChat from '../components/ManagerChat.vue'
import ScrollToTop from '../components/ScrollToTop.vue'
import ReadingProgress from '../components/ReadingProgress.vue'
import SmoothScroll from '../components/SmoothScroll.vue'

onMounted(() => {
  // Глобальные настройки анимаций при скролле
  const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
  }

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('animate-in')
      }
    })
  }, observerOptions)

  document.querySelectorAll('.fade-in-section').forEach(el => {
    observer.observe(el)
  })
})
</script>
