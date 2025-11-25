<template>
  <section id="faq" class="faq section fade-in-section">
    <div class="container">
      <h2 class="text-center mb-4">Ответы на популярные вопросы</h2>
      <div class="faq-list">
        <div 
          v-for="(faq, index) in faqs" 
          :key="index"
          class="faq-item glass"
          :class="{ active: activeFAQ === index }"
        >
          <button 
            class="faq-question"
            @click="toggleFAQ(index)"
          >
            <span>{{ faq.question }}</span>
            <component :is="activeFAQ === index ? Minus : Plus" :size="24" class="faq-icon" />
          </button>
          <div class="faq-answer">
            <p>{{ faq.answer }}</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { Plus, Minus } from 'lucide-vue-next'

const activeFAQ = ref(null)

const faqs = [
  {
    question: 'В чем заключается основное преимущество услуги фулфилмента?',
    answer: 'Фулфилмент позволяет эффективно управлять процессом выполнения заказов - хранением товаров, упаковкой и доставкой, освобождая время и ресурсы для развития бизнеса.'
  },
  {
    question: 'Какие виды услуг фулфилмента предлагает ваша компания?',
    answer: 'Наша компания предлагает полный спектр услуг по фулфилменту, включая хранение товаров, упаковку, подготовку к отправке и доставку заказов.'
  },
  {
    question: 'Какой опыт и квалификация у вашего персонала, занимающегося фулфилментом?',
    answer: 'Наш персонал имеет многолетний опыт работы в сфере фулфилмента и профессиональные навыки для качественного выполнения задач.'
  },
  {
    question: 'Каким образом можно отслеживать статус выполнения заказа при использовании услуг фулфилмента?',
    answer: 'Мы предоставляем доступ к онлайн-платформе, где клиенты могут отслеживать статус выполнения своих заказов и получать уведомления о доставке.'
  },
  {
    question: 'Какой минимальный объем заказов требуется для использования услуг фулфилмента?',
    answer: 'Мы работаем с клиентами разного масштаба и не устанавливаем минимального объема заказов для использования наших услуг фулфилмента.'
  }
]

const toggleFAQ = (index) => {
  activeFAQ.value = activeFAQ.value === index ? null : index
}
</script>

<style scoped>
.faq {
  background: var(--dark-light);
}

.faq-list {
  max-width: 900px;
  margin: 3rem auto 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.faq-item {
  border-radius: 16px;
  overflow: hidden;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  background: rgba(255, 255, 255, 0.02);
}

.faq-item.active {
  box-shadow: 
    0 12px 48px rgba(113, 59, 219, 0.35),
    inset 0 1px 0 rgba(255, 255, 255, 0.1);
  border-color: rgba(203, 17, 171, 0.5);
  background: rgba(255, 255, 255, 0.04);
  transform: translateY(-2px);
}

.faq-question {
  width: 100%;
  padding: 1.5rem 2rem;
  background: transparent;
  border: none;
  color: var(--white);
  font-size: 1.125rem;
  font-weight: 600;
  text-align: left;
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: all 0.3s ease;
}

.faq-question:hover {
  color: var(--primary-light);
}

.faq-icon {
  color: var(--primary);
  transition: transform 0.3s ease;
  min-width: 24px;
  flex-shrink: 0;
}

.faq-item.active .faq-icon {
  transform: rotate(180deg);
}

.faq-answer {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease, padding 0.3s ease;
}

.faq-item.active .faq-answer {
  max-height: 500px;
  padding: 0 2rem 1.5rem;
}

.faq-answer p {
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
}

@media (max-width: 768px) {
  .faq-question {
    padding: 1.25rem 1.5rem;
    font-size: 1rem;
  }

  .faq-item.active .faq-answer {
    padding: 0 1.5rem 1.25rem;
  }
}
</style>
