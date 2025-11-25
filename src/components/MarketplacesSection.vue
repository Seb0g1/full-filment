<template>
  <section id="services" class="marketplaces section fade-in-section">
    <div class="container">
      <h2 class="text-center mb-4">С кем мы работаем!</h2>
      <div class="marketplaces-grid">
        <div 
          v-for="(marketplace, index) in marketplaces" 
          :key="index"
          class="marketplace-card glass card-hover"
          :style="{ animationDelay: `${index * 0.1}s` }"
        >
          <div class="marketplace-logo">
            <img :src="marketplace.image" :alt="marketplace.name" />
          </div>
          <h3>{{ marketplace.name }}</h3>
          <p>{{ marketplace.description }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
const marketplaces = [
  { 
    name: 'Wildberries', 
    description: 'Специализированная интеграция',
    image: '/marketplaces/wildberries.svg'
  },
  { 
    name: 'Ozon', 
    description: 'Быстрая доставка FBO',
    image: '/marketplaces/ozon.svg'
  },
  { 
    name: 'Яндекс Маркет', 
    description: 'Полный цикл услуг',
    image: '/marketplaces/yandex-market.svg'
  },
  { 
    name: 'Сбер Маркет', 
    description: 'Оптимизация логистики',
    image: '/marketplaces/sber-market.svg'
  },
  { 
    name: 'CDEK', 
    description: 'Собственный транспорт',
    image: '/marketplaces/cdek.svg'
  },
]
</script>

<style scoped>
.marketplaces {
  background: linear-gradient(180deg, var(--dark) 0%, rgba(15, 23, 42, 0.8) 100%);
}

.marketplaces-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 2rem;
  margin-top: 3rem;
}

.marketplace-card {
  padding: 2.5rem 2rem;
  text-align: center;
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  position: relative;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.02);
}

.marketplace-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
  border-color: rgba(113, 59, 219, 0.3);
  background: rgba(255, 255, 255, 0.03);
}

.marketplace-logo {
  width: 100px;
  height: 100px;
  margin: 0 auto 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.3s ease;
}

.marketplace-logo img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  border-radius: 8px;
}

.marketplace-card:hover .marketplace-logo {
  transform: scale(1.05);
}

.marketplace-card h3 {
  font-size: 1.25rem;
  margin-bottom: 0.5rem;
  color: var(--white);
}

.marketplace-card p {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.875rem;
}

@media (max-width: 768px) {
  .marketplaces-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem;
  }

  .marketplace-card {
    padding: 1.5rem;
  }
}
</style>
