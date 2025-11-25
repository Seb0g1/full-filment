<template>
  <section class="process section fade-in-section">
    <div class="container">
      <h2 class="text-center mb-4">Работаем четко и по графику</h2>
      <div class="process-timeline">
        <div 
          v-for="(step, index) in steps" 
          :key="index"
          class="process-step"
          :class="{ active: activeStep >= index }"
        >
          <div class="step-number">{{ index + 1 }}</div>
          <div class="step-content glass">
            <component :is="step.iconComponent" :size="48" class="step-icon" />
            <h3>{{ step.title }}</h3>
            <ul class="step-list">
              <li v-for="(item, i) in step.items" :key="i">{{ item }}</li>
            </ul>
          </div>
          <div v-if="index < steps.length - 1" class="step-connector"></div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Phone, FileText, Package, CheckSquare, Truck } from 'lucide-vue-next'

const activeStep = ref(-1)

const steps = [
  {
    iconComponent: Phone,
    title: 'Брифинг',
    items: [
      'Оставьте заявку на сайте, позвоните или напишите нам',
      'Мы согласуем все детали и договоримся об оказании услуг'
    ]
  },
  {
    iconComponent: FileText,
    title: 'Расчет',
    items: [
      'Формируем техническое задание',
      'Делаем расчет цены',
      'Оформляем договора'
    ]
  },
  {
    iconComponent: Package,
    title: 'Забор груза',
    items: [
      'Забираем товар с вашего склада, рынка, транспортной компании',
      'Или принимаем его на свой склад'
    ]
  },
  {
    iconComponent: CheckSquare,
    title: 'Сортировка и упаковка',
    items: [
      'Проверяем',
      'Считаем и сортируем',
      'Упаковываем',
      'Готовим к отгрузкам'
    ]
  },
  {
    iconComponent: CheckSquare,
    title: 'Согласование',
    items: [
      'Высылаем по требованию фотоотчет всех этапов упаковки',
      'Прием работы',
      'Оплата работы'
    ]
  },
  {
    iconComponent: Truck,
    title: 'Отгрузка',
    items: [
      'Оформление поставки',
      'Отгрузка товара на склад'
    ]
  }
]

onMounted(() => {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateSteps()
        observer.disconnect()
      }
    })
  }, { threshold: 0.2 })

  const section = document.querySelector('.process')
  if (section) observer.observe(section)
})

const animateSteps = () => {
  steps.forEach((_, index) => {
    setTimeout(() => {
      activeStep.value = index
    }, index * 300)
  })
}
</script>

<style scoped>
.process {
  background: linear-gradient(180deg, rgba(15, 23, 42, 0.8) 0%, var(--dark) 100%);
}

.process-timeline {
  max-width: 900px;
  margin: 3rem auto 0;
  position: relative;
}

.process-step {
  position: relative;
  margin-bottom: 3rem;
  opacity: 0;
  transform: translateX(-30px);
  transition: all 0.5s ease;
}

.process-step.active {
  opacity: 1;
  transform: translateX(0);
}

.step-number {
  position: absolute;
  left: -60px;
  top: 0;
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: var(--gradient-rainbow);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: 800;
  color: var(--white);
  box-shadow: 
    0 8px 24px rgba(113, 59, 219, 0.5),
    0 0 0 4px rgba(203, 17, 171, 0.15),
    inset 0 1px 0 rgba(255, 255, 255, 0.3);
  z-index: 2;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.process-step.active .step-number {
  transform: scale(1.15);
  box-shadow: 
    0 12px 32px rgba(203, 17, 171, 0.7),
    0 0 0 6px rgba(113, 59, 219, 0.2),
    inset 0 1px 0 rgba(255, 255, 255, 0.4);
  animation: pulse-number 2s ease-in-out infinite;
}

@keyframes pulse-number {
  0%, 100% {
    transform: scale(1.15);
  }
  50% {
    transform: scale(1.25);
  }
}

.step-content {
  margin-left: 2rem;
  padding: 2rem;
  transition: all 0.3s ease;
}

.process-step.active .step-content {
  border-color: rgba(203, 17, 171, 0.5);
  box-shadow: 
    0 12px 48px rgba(113, 59, 219, 0.35),
    inset 0 1px 0 rgba(255, 255, 255, 0.15);
  background: rgba(255, 255, 255, 0.04);
  transform: translateX(5px);
}

.step-icon {
  margin-bottom: 1rem;
  color: var(--primary-light);
  filter: drop-shadow(0 5px 15px rgba(113, 59, 219, 0.4));
}

.step-content h3 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: var(--white);
}

.step-list {
  list-style: none;
  padding: 0;
}

.step-list li {
  color: rgba(255, 255, 255, 0.7);
  padding: 0.5rem 0;
  padding-left: 1.5rem;
  position: relative;
}

.step-list li::before {
  content: '✓';
  position: absolute;
  left: 0;
  color: var(--secondary);
  font-weight: bold;
}

.step-connector {
  position: absolute;
  left: -35px;
  top: 50px;
  width: 2px;
  height: calc(100% + 1rem);
  background: rgba(255, 255, 255, 0.2);
}

.step-connector::after {
  content: '';
  position: absolute;
  top: 0;
  left: -1px;
  width: 4px;
  height: 0;
  background: var(--gradient-primary);
  transition: height 0.5s ease;
}

.process-step.active + .process-step .step-connector::after {
  height: 100%;
}

@media (max-width: 768px) {
  .step-number {
    position: relative;
    left: 0;
    margin-bottom: 1rem;
  }

  .step-content {
    margin-left: 0;
  }

  .step-connector {
    display: none;
  }
}
</style>
