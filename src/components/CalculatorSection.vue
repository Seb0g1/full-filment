<template>
  <section id="calculator" class="calculator section fade-in-section">
    <div class="container">
      <div class="calculator-wrapper glass">
        <div class="calculator-header text-center mb-4">
          <h2>Рассчитайте стоимость</h2>
          <p>Ответьте на несколько вопросов и получите точный расчет</p>
        </div>
        <form @submit.prevent="submitCalculator" class="calculator-form">
          <div class="form-step" v-show="currentStep === 0">
            <h3>С каким маркетплейсом вы бы хотели поработать?</h3>
            <div class="checkbox-group">
              <label 
                v-for="marketplace in marketplaces" 
                :key="marketplace"
                class="checkbox-label"
              >
                <input 
                  type="checkbox" 
                  :value="marketplace"
                  v-model="formData.marketplaces"
                />
                <span>{{ marketplace }}</span>
              </label>
            </div>
          </div>

          <div class="form-step" v-show="currentStep === 1">
            <h3>Какое у Вас направление бизнеса?</h3>
            <div class="business-types-grid">
              <label 
                v-for="type in businessTypes" 
                :key="type"
                class="business-type-card"
                :class="{ active: formData.businessType === type }"
              >
                <input 
                  type="radio" 
                  :value="type"
                  v-model="formData.businessType"
                  name="businessType"
                  class="sr-only"
                />
                <span class="business-type-text">{{ type }}</span>
              </label>
            </div>
          </div>

          <div class="form-step" v-show="currentStep === 2">
            <h3>Какой объем заказов вы хотите продавать в месяц?</h3>
            <div class="radio-group">
              <label 
                v-for="volume in orderVolumes" 
                :key="volume.value"
                class="radio-label"
              >
                <input 
                  type="radio" 
                  :value="volume.value"
                  v-model="formData.orderVolume"
                  name="orderVolume"
                />
                <span>{{ volume.label }}</span>
              </label>
            </div>
          </div>

          <div class="form-step" v-show="currentStep === 3">
            <h3>В каком регионе у вас находится склад или производство?</h3>
            <div class="select-group">
              <div class="select-wrapper">
                <select 
                  v-model="formData.region"
                  @change="formData.city = ''"
                  class="form-select"
                >
                  <option value="">Выберите регион</option>
                  <option 
                    v-for="region in regions" 
                    :key="region"
                    :value="region"
                  >
                    {{ region }}
                  </option>
                </select>
                <ChevronDown :size="20" class="select-icon" />
              </div>
            </div>
            <div v-if="formData.region && availableCities.length > 0" class="select-group">
              <div class="select-wrapper">
                <select 
                  v-model="formData.city"
                  class="form-select"
                >
                  <option value="">Выберите город</option>
                  <option 
                    v-for="city in availableCities" 
                    :key="city"
                    :value="city"
                  >
                    {{ city }}
                  </option>
                </select>
                <ChevronDown :size="20" class="select-icon" />
              </div>
            </div>
            <div v-if="formData.region && availableCities.length === 0" class="select-group">
              <input 
                type="text" 
                v-model="formData.city"
                placeholder="Укажите город"
                class="form-input"
              />
            </div>
          </div>

          <div class="form-step" v-show="currentStep === 4">
            <h3>На какой срок вы планируете арендовать склад?</h3>
            <div class="radio-group">
              <label 
                v-for="period in rentalPeriods" 
                :key="period.value"
                class="radio-label"
              >
                <input 
                  type="radio" 
                  :value="period.value"
                  v-model="formData.rentalPeriod"
                  name="rentalPeriod"
                />
                <span>{{ period.label }}</span>
              </label>
            </div>
          </div>

          <div class="form-step" v-show="currentStep === 5">
            <h3>Куда Вам выслать расчет?</h3>
            <div class="contact-methods">
              <label 
                v-for="method in contactMethods" 
                :key="method.value"
                class="radio-label"
              >
                <input 
                  type="radio" 
                  :value="method.value"
                  v-model="formData.contactMethod"
                  name="contactMethod"
                />
                <span>{{ method.label }}</span>
              </label>
            </div>
            <div class="form-row" :class="{ 'form-row-telegram': formData.contactMethod === 'telegram' }">
              <input 
                type="text" 
                v-model="formData.name"
                placeholder="Ваше имя"
                class="form-input"
                required
              />
              <!-- Динамическое поле ввода в зависимости от способа связи -->
              <template v-if="formData.contactMethod === 'email'">
                <input 
                  type="email" 
                  v-model="formData.email"
                  placeholder="Ваш email"
                  class="form-input"
                  required
                />
              </template>
              <template v-else-if="formData.contactMethod === 'telegram'">
                <input 
                  type="text" 
                  v-model="formData.telegramTag"
                  placeholder="@username (необязательно)"
                  class="form-input"
                />
                <input 
                  type="tel" 
                  v-model="formData.phone"
                  placeholder="Номер телефона"
                  class="form-input"
                  required
                />
              </template>
              <input 
                v-else
                type="tel" 
                v-model="formData.phone"
                :placeholder="getContactPlaceholder()"
                class="form-input"
                required
              />
            </div>
          </div>

          <div class="form-actions">
            <button 
              v-if="currentStep > 0" 
              type="button" 
              @click="prevStep"
              class="btn btn-secondary"
            >
              Назад
            </button>
            <button 
              v-if="currentStep < 5" 
              type="button" 
              @click="nextStep"
              class="btn"
            >
              Далее
            </button>
            <button 
              v-if="currentStep === 5" 
              type="submit"
              class="btn"
              :disabled="isSubmitting"
            >
              {{ isSubmitting ? 'Отправка...' : 'Получить расчет' }}
            </button>
          </div>

          <div class="form-progress">
            <div class="progress-bar">
              <div 
                class="progress-fill" 
                :style="{ width: `${((currentStep + 1) / 6) * 100}%` }"
              ></div>
            </div>
            <span class="progress-text">Шаг: {{ currentStep + 1 }} / 6</span>
          </div>
        </form>
      </div>
      <Modal 
        v-model="showModal"
        :type="modalType"
        :title="modalTitle"
        :message="modalMessage"
      />
    </div>
  </section>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { ChevronDown } from 'lucide-vue-next'
import { sendTelegramMessage, formatCalculatorMessage } from '../utils/telegram'
import { getRegions, getCities } from '../utils/russianRegions'
import Modal from './Modal.vue'

const currentStep = ref(0)
const formData = reactive({
  marketplaces: [],
  businessType: '',
  orderVolume: '',
  region: '',
  city: '',
  rentalPeriod: '',
  contactMethod: '',
  name: '',
  phone: '',
  email: '',
  telegramTag: ''
})

const getContactPlaceholder = () => {
  switch (formData.contactMethod) {
    case 'phone':
      return 'Ваш номер телефона'
    case 'whatsapp':
      return 'Ваш номер WhatsApp'
    case 'viber':
      return 'Ваш номер Viber'
    default:
      return 'Ваш номер телефона'
  }
}

const regions = getRegions()

const availableCities = computed(() => {
  if (!formData.region) return []
  return getCities(formData.region)
})

const marketplaces = ['Сбер маркет', 'Озон', 'Вайлдберриз', 'Яндекс Маркет', 'Авито/Юла', 'Другое']
const businessTypes = ['Книги', 'Украшения', 'Товары для животных', 'Инструменты', 'Канцтовары', 'Товары для ремонта', 'Стройматериалы', 'Техника', 'Косметика', 'Товары для спорта', 'Товары для детей', 'Одежда и обувь', 'Мебель', 'Другое']
const orderVolumes = [
  { value: '1000', label: 'До 1000 заказов' },
  { value: '5000', label: 'До 5000 заказов' },
  { value: '10000', label: 'До 10000 заказов' },
  { value: '20000', label: 'До 20000 заказов' },
  { value: '50000', label: 'До 50000 заказов' },
  { value: '100000', label: 'До 100000 заказов' },
  { value: '100000+', label: 'Свыше 100000 заказов' }
]
const rentalPeriods = [
  { value: '1', label: 'До 1 месяца' },
  { value: '3', label: 'До 3-х месяцев' },
  { value: '6', label: 'До 6 месяцев' },
  { value: '12', label: 'До 1 года' },
  { value: '12+', label: 'Свыше 1 года' }
]
const contactMethods = [
  { value: 'phone', label: 'По телефону' },
  { value: 'telegram', label: 'Телеграм' },
  { value: 'whatsapp', label: 'WhatsApp' },
  { value: 'viber', label: 'Viber' },
  { value: 'email', label: 'Email' }
]

const nextStep = () => {
  if (currentStep.value < 5) {
    currentStep.value++
  }
}

const prevStep = () => {
  if (currentStep.value > 0) {
    currentStep.value--
  }
}

const isSubmitting = ref(false)
const showModal = ref(false)
const modalType = ref('success')
const modalTitle = ref('')
const modalMessage = ref('')

const validateForm = () => {
  const errors = []
  
  if (!formData.marketplaces || formData.marketplaces.length === 0) {
    errors.push('Выберите хотя бы один маркетплейс')
  }
  
  if (!formData.businessType) {
    errors.push('Выберите направление бизнеса')
  }
  
  if (!formData.orderVolume) {
    errors.push('Укажите объем заказов')
  }
  
  if (!formData.region || !formData.region.trim()) {
    errors.push('Выберите регион')
  }
  
  if (!formData.city || !formData.city.trim()) {
    errors.push('Выберите или укажите город')
  }
  
  if (!formData.rentalPeriod) {
    errors.push('Выберите срок аренды')
  }
  
  if (!formData.contactMethod) {
    errors.push('Выберите способ связи')
  }
  
  if (!formData.name || !formData.name.trim()) {
    errors.push('Укажите ваше имя')
  }
  
  // Валидация контактных данных в зависимости от способа связи
  if (formData.contactMethod === 'email') {
    if (!formData.email || !formData.email.trim()) {
      errors.push('Укажите ваш email')
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      errors.push('Укажите корректный email')
    }
  } else if (formData.contactMethod === 'telegram') {
    if (!formData.phone || !formData.phone.trim()) {
      errors.push('Укажите ваш номер телефона')
    }
  } else {
    if (!formData.phone || !formData.phone.trim()) {
      errors.push('Укажите ваш номер телефона')
    }
  }
  
  return errors
}

const showErrorModal = (message) => {
  modalType.value = 'error'
  modalTitle.value = 'Ошибка заполнения'
  modalMessage.value = message
  showModal.value = true
}

const showSuccessModal = (message) => {
  modalType.value = 'success'
  modalTitle.value = 'Заявка отправлена!'
  modalMessage.value = message
  showModal.value = true
}

const submitCalculator = async () => {
  if (isSubmitting.value) return
  
  // Валидация
  const errors = validateForm()
  if (errors.length > 0) {
    showErrorModal('Пожалуйста, заполните все обязательные поля:<br><br>' + errors.join('<br>'))
    return
  }
  
  isSubmitting.value = true
  modalType.value = 'loading'
  modalTitle.value = 'Отправка...'
  modalMessage.value = 'Пожалуйста, подождите'
  showModal.value = true
  
  try {
    const message = formatCalculatorMessage(formData)
    const success = await sendTelegramMessage(message, 'calculator')
    
    if (success) {
      showSuccessModal('Спасибо за заявку!<br>Мы свяжемся с вами в ближайшее время и предоставим расчет стоимости.')
      // Сброс формы
      formData.marketplaces = []
      formData.businessType = ''
      formData.orderVolume = ''
      formData.region = ''
      formData.city = ''
      formData.rentalPeriod = ''
      formData.contactMethod = ''
      formData.name = ''
      formData.phone = ''
      formData.email = ''
      formData.telegramTag = ''
      currentStep.value = 0
    } else {
      showErrorModal('Произошла ошибка при отправке.<br>Пожалуйста, попробуйте позже или свяжитесь с нами по телефону.')
    }
  } catch (error) {
    console.error('Error submitting calculator:', error)
    showErrorModal('Произошла ошибка при отправке.<br>Пожалуйста, попробуйте позже.')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.calculator {
  background: linear-gradient(180deg, var(--dark) 0%, var(--dark-light) 100%);
}

.calculator-wrapper {
  max-width: 900px;
  margin: 0 auto;
  padding: 3rem 2.5rem;
  background: rgba(255, 255, 255, 0.02);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 20px;
}

.calculator-header h2 {
  margin-bottom: 1rem;
}

.calculator-header p {
  color: rgba(255, 255, 255, 0.7);
  font-size: 1.125rem;
}

.form-step {
  margin-bottom: 2rem;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateX(20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.form-step h3 {
  margin-bottom: 1.5rem;
  color: var(--white);
}

.checkbox-group,
.radio-group,
.contact-methods {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

.checkbox-label,
.radio-label {
  display: flex;
  align-items: center;
  padding: 0.875rem 1rem;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.checkbox-label:hover,
.radio-label:hover {
  background: rgba(255, 255, 255, 0.05);
  border-color: rgba(113, 59, 219, 0.3);
}

.checkbox-label:has(input:checked),
.radio-label:has(input:checked) {
  background: rgba(113, 59, 219, 0.1);
  border-color: var(--primary);
  border-width: 2px;
}

.checkbox-label input,
.radio-label input {
  margin-right: 0.75rem;
  width: 20px;
  height: 20px;
  cursor: pointer;
}

.checkbox-label input:checked + span,
.radio-label input:checked + span {
  color: var(--primary-light);
  font-weight: 600;
}

.business-types-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 0.75rem;
  margin-top: 1.5rem;
}

.business-type-card {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem 1.25rem;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
  text-align: center;
  min-height: 56px;
}

.business-type-card:hover {
  background: rgba(255, 255, 255, 0.05);
  border-color: rgba(113, 59, 219, 0.3);
}

.business-type-card.active {
  background: rgba(113, 59, 219, 0.1);
  border-color: var(--primary);
  border-width: 2px;
}

.business-type-text {
  color: rgba(255, 255, 255, 0.9);
  font-size: 0.9375rem;
  font-weight: 500;
}

.business-type-card.active .business-type-text {
  color: var(--primary-light);
  font-weight: 600;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

.select-group {
  margin-bottom: 1rem;
}

.select-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.select-wrapper .select-icon {
  position: absolute;
  right: 1rem;
  pointer-events: none;
  color: rgba(255, 255, 255, 0.5);
  transition: color 0.3s ease, transform 0.3s ease;
}

.select-wrapper:has(.form-select:focus) .select-icon {
  color: var(--primary-light);
  transform: rotate(180deg);
}

.form-select,
.form-input {
  width: 100%;
  padding: 1rem;
  padding-right: 3rem;
  background: rgba(255, 255, 255, 0.05);
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  color: var(--white);
  font-size: 1rem;
  transition: all 0.3s ease;
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  cursor: pointer;
  font-family: inherit;
}

.form-select:hover {
  background: rgba(255, 255, 255, 0.07);
  border-color: rgba(255, 255, 255, 0.15);
}

.form-select:focus,
.form-input:focus {
  outline: none;
  border-color: var(--primary);
  background: rgba(255, 255, 255, 0.08);
  box-shadow: 
    0 0 0 3px rgba(113, 59, 219, 0.15),
    0 4px 12px rgba(113, 59, 219, 0.1);
}

.form-select option {
  background: var(--dark-light);
  color: var(--white);
  padding: 0.5rem;
}

.form-input {
  padding-right: 1rem;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-top: 1rem;
}

.form-row-telegram {
  grid-template-columns: 1fr 1fr 1fr;
}

@media (max-width: 768px) {
  .form-row {
    grid-template-columns: 1fr;
  }

  .form-row-telegram {
    grid-template-columns: 1fr;
  }
}

.form-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  margin-top: 2rem;
}

.form-progress {
  margin-top: 2rem;
}

.progress-bar {
  width: 100%;
  height: 8px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  overflow: hidden;
  margin-bottom: 0.5rem;
}

.progress-fill {
  height: 100%;
  background: var(--gradient-rainbow);
  transition: width 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 10px;
  box-shadow: 
    0 0 10px rgba(113, 59, 219, 0.6),
    inset 0 1px 0 rgba(255, 255, 255, 0.2);
  position: relative;
  overflow: hidden;
}

.progress-fill::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.3),
    transparent
  );
  animation: shimmer 2s infinite;
}

@keyframes shimmer {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

.progress-text {
  display: block;
  text-align: center;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.875rem;
}

@media (max-width: 768px) {
  .calculator-wrapper {
    padding: 2rem 1.5rem;
  }

  .checkbox-group,
  .radio-group,
  .contact-methods {
    grid-template-columns: 1fr;
  }

  .form-row {
    grid-template-columns: 1fr;
  }
}
</style>
