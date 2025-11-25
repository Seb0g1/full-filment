<template>
  <section id="contacts" class="contact section fade-in-section">
    <div class="container">
      <div class="contact-wrapper">
        <div class="contact-info glass">
          <h2>Остались вопросы?</h2>
          <p>Свяжитесь с нами любым удобным способом</p>
          <div class="contact-details">
            <div class="contact-item">
              <Phone :size="32" class="contact-icon" />
              <div>
                <h3>Телефон</h3>
                <a href="tel:+79002797068">+7 (900) 279-70-68</a>
              </div>
            </div>
            <div class="contact-item">
              <MapPin :size="32" class="contact-icon" />
              <div>
                <h3>Адрес</h3>
                <p>МКАД 33 км, 6, Москва, 117405</p>
              </div>
            </div>
            <div class="contact-item">
              <Clock :size="32" class="contact-icon" />
              <div>
                <h3>Время работы</h3>
                <p>С 9:00 утра до 22:00 вечера</p>
              </div>
            </div>
          </div>
        </div>
        <div class="contact-form-wrapper glass">
          <h2>Оставить заявку</h2>
          <form @submit.prevent="submitContact" class="contact-form">
            <input 
              type="text" 
              v-model="contactForm.name"
              placeholder="Ваше имя"
              class="form-input"
              required
            />
            <input 
              type="tel" 
              v-model="contactForm.phone"
              placeholder="Ваш номер телефона"
              class="form-input"
              required
            />
            <textarea 
              v-model="contactForm.message"
              placeholder="Ваше сообщение (необязательно)"
              class="form-textarea"
              rows="4"
            ></textarea>
            <label class="checkbox-label-form">
              <input 
                type="checkbox" 
                v-model="contactForm.privacy"
                required
              />
              <span>Согласиться с политикой конфиденциальности</span>
            </label>
            <button type="submit" class="btn btn-large" :disabled="isSubmitting">
              <Send :size="20" v-if="!isSubmitting" style="margin-right: 0.5rem;" />
              {{ isSubmitting ? 'Отправка...' : 'Отправить' }}
            </button>
          </form>
        </div>
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
import { reactive, ref } from 'vue'
import { Phone, MapPin, Clock, Send } from 'lucide-vue-next'
import { sendTelegramMessage, formatContactMessage } from '../utils/telegram'
import Modal from './Modal.vue'

const contactForm = reactive({
  name: '',
  phone: '',
  message: '',
  privacy: false
})

const isSubmitting = ref(false)
const showModal = ref(false)
const modalType = ref('success')
const modalTitle = ref('')
const modalMessage = ref('')

const validateForm = () => {
  const errors = []
  
  if (!contactForm.name.trim()) {
    errors.push('Пожалуйста, укажите ваше имя')
  }
  
  if (!contactForm.phone.trim()) {
    errors.push('Пожалуйста, укажите ваш номер телефона')
  }
  
  if (!contactForm.privacy) {
    errors.push('Необходимо согласиться с политикой конфиденциальности')
  }
  
  return errors
}

const showErrorModal = (message) => {
  modalType.value = 'error'
  modalTitle.value = 'Ошибка'
  modalMessage.value = message
  showModal.value = true
}

const showSuccessModal = (message) => {
  modalType.value = 'success'
  modalTitle.value = 'Спасибо!'
  modalMessage.value = message
  showModal.value = true
}

const submitContact = async () => {
  if (isSubmitting.value) return
  
  // Валидация
  const errors = validateForm()
  if (errors.length > 0) {
    showErrorModal(errors.join('<br>'))
    return
  }
  
  isSubmitting.value = true
  modalType.value = 'loading'
  modalTitle.value = 'Отправка...'
  modalMessage.value = 'Пожалуйста, подождите'
  showModal.value = true
  
  try {
    const message = formatContactMessage(contactForm)
    const success = await sendTelegramMessage(message, 'contact')
    
    if (success) {
      showSuccessModal('Спасибо за обращение!<br>Мы свяжемся с вами в ближайшее время.')
      contactForm.name = ''
      contactForm.phone = ''
      contactForm.message = ''
      contactForm.privacy = false
    } else {
      showErrorModal('Произошла ошибка при отправке.<br>Пожалуйста, попробуйте позже или свяжитесь с нами по телефону.')
    }
  } catch (error) {
    console.error('Error submitting form:', error)
    showErrorModal('Произошла ошибка при отправке.<br>Пожалуйста, попробуйте позже.')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.contact {
  background: linear-gradient(180deg, var(--dark) 0%, var(--dark-light) 100%);
}

.contact-wrapper {
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  gap: 3rem;
  max-width: 1200px;
  margin: 0 auto;
}

.contact-info,
.contact-form-wrapper {
  padding: 2.5rem;
  background: rgba(255, 255, 255, 0.02);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 20px;
}

.contact-info h2 {
  margin-bottom: 1rem;
}

.contact-info p {
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 2rem;
}

.contact-details {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.contact-item {
  display: flex;
  gap: 1.5rem;
  align-items: flex-start;
}

.contact-icon {
  color: var(--primary);
  flex-shrink: 0;
  opacity: 0.8;
}

.contact-item h3 {
  font-size: 1.125rem;
  margin-bottom: 0.5rem;
  color: var(--white);
}

.contact-item a {
  color: rgba(255, 255, 255, 0.9);
  text-decoration: none;
  font-weight: 500;
  transition: color 0.2s ease;
}

.contact-item a:hover {
  color: var(--primary-light);
}

.contact-item p {
  color: rgba(255, 255, 255, 0.7);
  margin: 0;
}

.contact-form-wrapper h2 {
  margin-bottom: 2rem;
}

.contact-form {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.contact-form .form-input {
  width: 100%;
  padding: 0.875rem 1rem;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: var(--white);
  font-size: 1rem;
  font-family: inherit;
  transition: all 0.2s ease;
}

.contact-form .form-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.contact-form .form-input:focus {
  outline: none;
  border-color: var(--primary);
  background: rgba(255, 255, 255, 0.05);
  box-shadow: 0 0 0 3px rgba(113, 59, 219, 0.1);
}

.form-textarea {
  width: 100%;
  padding: 0.875rem 1rem;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: var(--white);
  font-size: 1rem;
  font-family: inherit;
  resize: vertical;
  transition: all 0.2s ease;
  min-height: 120px;
}

.form-textarea::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.form-textarea:focus {
  outline: none;
  border-color: var(--primary);
  background: rgba(255, 255, 255, 0.05);
  box-shadow: 0 0 0 3px rgba(113, 59, 219, 0.1);
}

.checkbox-label-form {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
}

.checkbox-label-form input {
  width: 20px;
  height: 20px;
  cursor: pointer;
}

@media (max-width: 968px) {
  .contact-wrapper {
    grid-template-columns: 1fr;
    gap: 2rem;
  }

  .contact-info,
  .contact-form-wrapper {
    padding: 2rem;
  }
}
</style>
