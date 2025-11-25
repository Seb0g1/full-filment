<template>
  <section class="advantages section fade-in-section">
    <div class="container">
      <h2 class="text-center mb-4">Почему мы?</h2>
      <div class="advantages-grid">
        <div 
          v-for="(advantage, index) in advantages" 
          :key="index"
          class="advantage-card glass card-hover"
          :style="{ animationDelay: `${index * 0.15}s` }"
        >
          <component :is="advantage.iconComponent" :size="48" class="advantage-icon" />
          <h3>{{ advantage.title }}</h3>
          <p>{{ advantage.description }}</p>
          <div class="advantage-badge">{{ advantage.badge }}</div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { Zap, Truck, Shield, MessageCircle, Video, Warehouse } from 'lucide-vue-next'

const advantages = [
  {
    iconComponent: Zap,
    title: 'Скорость',
    description: 'Наш склад находится рядом с почтовыми пунктами КАРГО, что позволяет сокращать время от забора до поставки на склад маркетплейсов. Среднее время поставок - 2 дня.',
    badge: '2 дня'
  },
  {
    iconComponent: Truck,
    title: 'Свой транспорт',
    description: 'Наличие собственного автопарка позволяет ежедневно забирать товары у поставщиков.',
    badge: '24/7'
  },
  {
    iconComponent: Shield,
    title: 'Материальная ответственность',
    description: 'Компенсируем стоимость расходов в случае нарушения сроков или совершения ошибки по нашей вине.',
    badge: '100%'
  },
  {
    iconComponent: MessageCircle,
    title: 'Поддержка 24/7',
    description: 'За вами закрепляется персональный менеджер, который знает ваш товар и все нюансы упаковки',
    badge: 'Индивидуально'
  },
  {
    iconComponent: Video,
    title: 'Видеофиксация',
    description: 'На складе установлена современная система видеонаблюдения, в случае спорных моментов можно отследить каждый из этапов.',
    badge: 'Безопасно'
  },
  {
    iconComponent: Warehouse,
    title: 'Чистый склад',
    description: 'Современный охраняемый склад с контролем влажности и температуры, и всем необходимым для разгрузки товара.',
    badge: 'Контроль'
  }
]
</script>

<style scoped>
.advantages {
  background: linear-gradient(180deg, var(--dark) 0%, var(--dark-light) 50%, var(--dark) 100%);
  position: relative;
  overflow: hidden;
}

.advantages::before {
  content: '';
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 600px;
  height: 600px;
  background: radial-gradient(circle, rgba(113, 59, 219, 0.15) 0%, transparent 70%);
  border-radius: 50%;
  filter: blur(80px);
  pointer-events: none;
}

.advantages-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin-top: 3rem;
}

.advantage-card {
  padding: 2.5rem;
  position: relative;
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.02);
}

.advantage-card::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--gradient-primary);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 0.3s ease;
}

.advantage-card:hover::after {
  transform: scaleX(1);
}

.advantage-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
  border-color: rgba(113, 59, 219, 0.3);
  background: rgba(255, 255, 255, 0.03);
}

.advantage-icon {
  margin-bottom: 1rem;
  color: var(--primary);
  opacity: 0.9;
  transition: transform 0.3s ease;
}

.advantage-card:hover .advantage-icon {
  transform: scale(1.05);
}

.advantage-card h3 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: var(--white);
}

.advantage-card p {
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
  margin-bottom: 1.5rem;
}

.advantage-badge {
  display: inline-block;
  padding: 0.625rem 1.25rem;
  background: var(--gradient-primary);
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--white);
  box-shadow: 
    0 4px 12px rgba(113, 59, 219, 0.5),
    inset 0 1px 0 rgba(255, 255, 255, 0.2);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.advantage-badge::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
  transition: left 0.5s;
}

.advantage-card:hover .advantage-badge::before {
  left: 100%;
}

.advantage-card:hover .advantage-badge {
  transform: scale(1.05);
  box-shadow: 
    0 6px 20px rgba(203, 17, 171, 0.7),
    inset 0 1px 0 rgba(255, 255, 255, 0.3);
}

@media (max-width: 768px) {
  .advantages-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }

  .advantage-card {
    padding: 2rem;
  }
}
</style>
