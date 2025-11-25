<template>
  <div v-if="isVisible" class="settings-overlay" @click.self="close">
    <div class="settings-panel glass">
      <div class="settings-header">
        <h2>Настройки Telegram бота</h2>
        <button class="close-btn" @click="close" aria-label="Закрыть">
          <X :size="24" />
        </button>
      </div>

      <div class="settings-content">
        <div class="settings-section">
          <p class="settings-description">
            Настройте получение заявок и обращений в Telegram. 
            Все данные сохраняются локально в браузере.
          </p>
        </div>

        <form @submit.prevent="saveSettings" class="settings-form">
          <div class="form-field">
            <label for="bot-token" class="form-label">
              Токен бота
              <span class="form-hint">
                Получите у <a href="https://t.me/BotFather" target="_blank">@BotFather</a>
              </span>
            </label>
            <input
              id="bot-token"
              v-model="form.token"
              type="password"
              class="form-input"
              placeholder="123456789:ABCdefGHIjklMNOpqrsTUVwxyz"
              required
            />
            <button
              type="button"
              class="toggle-password"
              @click="showToken = !showToken"
            >
              <Eye v-if="!showToken" :size="18" />
              <EyeOff v-else :size="18" />
            </button>
          </div>

          <div class="form-field">
            <label for="chat-id" class="form-label">
              Chat ID
              <span class="form-hint">
                Получите у <a href="https://t.me/userinfobot" target="_blank">@userinfobot</a> 
                или из группы
              </span>
            </label>
            <input
              id="chat-id"
              v-model="form.chatId"
              type="text"
              class="form-input"
              placeholder="123456789 или -123456789 для группы"
              required
            />
          </div>

          <div class="settings-actions">
            <button
              type="button"
              @click="testConnection"
              class="btn btn-secondary"
              :disabled="isTesting || !form.token || !form.chatId"
            >
              <Loader2 v-if="isTesting" :size="18" class="spinner" />
              <span v-else>Проверить подключение</span>
            </button>
            <button
              type="submit"
              class="btn"
              :disabled="isSaving || !form.token || !form.chatId"
            >
              <Loader2 v-if="isSaving" :size="18" class="spinner" />
              <span v-else>Сохранить настройки</span>
            </button>
          </div>

          <div v-if="testResult" class="test-result" :class="{ success: testResult.success, error: !testResult.success }">
            <CheckCircle v-if="testResult.success" :size="20" />
            <AlertCircle v-else :size="20" />
            <span>{{ testResult.message }}</span>
          </div>
        </form>

        <div class="settings-info">
          <h3>Инструкция</h3>
          <ol>
            <li>Создайте бота через <a href="https://t.me/BotFather" target="_blank">@BotFather</a></li>
            <li>Скопируйте токен бота</li>
            <li>Получите ваш Chat ID через <a href="https://t.me/userinfobot" target="_blank">@userinfobot</a></li>
            <li>Или добавьте бота в группу и получите ID группы</li>
            <li>Вставьте данные и нажмите "Сохранить"</li>
          </ol>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch } from 'vue'
import { X, Eye, EyeOff, Loader2, CheckCircle, AlertCircle } from 'lucide-vue-next'
import { getTelegramConfig, saveTelegramConfig, testTelegramConfig } from '../utils/telegram'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue'])

const isVisible = ref(props.modelValue)
const showToken = ref(false)
const isSaving = ref(false)
const isTesting = ref(false)
const testResult = ref(null)

const form = reactive({
  token: '',
  chatId: ''
})

const loadSettings = () => {
  const config = getTelegramConfig()
  form.token = config.token
  form.chatId = config.chatId
}

const saveSettings = async () => {
  if (!form.token || !form.chatId) return

  isSaving.value = true
  testResult.value = null

  try {
    saveTelegramConfig(form.token, form.chatId)
    testResult.value = {
      success: true,
      message: 'Настройки сохранены успешно!'
    }
    
    setTimeout(() => {
      close()
    }, 1500)
  } catch (error) {
    testResult.value = {
      success: false,
      message: 'Ошибка при сохранении настроек'
    }
  } finally {
    isSaving.value = false
  }
}

const testConnection = async () => {
  if (!form.token || !form.chatId) return

  isTesting.value = true
  testResult.value = null

  try {
    const result = await testTelegramConfig(form.token, form.chatId)
    if (result.success) {
      testResult.value = {
        success: true,
        message: 'Подключение успешно! Тестовое сообщение отправлено в Telegram.'
      }
    } else {
      testResult.value = {
        success: false,
        message: result.error || 'Ошибка при проверке подключения'
      }
    }
  } catch (error) {
    testResult.value = {
      success: false,
      message: 'Ошибка при проверке подключения'
    }
  } finally {
    isTesting.value = false
  }
}

const close = () => {
  isVisible.value = false
  emit('update:modelValue', false)
}

onMounted(() => {
  loadSettings()
  
  // Следим за изменениями modelValue
  watch(() => props.modelValue, (newVal) => {
    isVisible.value = newVal
    if (newVal) {
      loadSettings()
    }
  })
})
</script>

<style scoped>
.settings-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(8px);
  z-index: 10000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  animation: fadeIn 0.2s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.settings-panel {
  width: 100%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
  animation: slideUp 0.3s ease;
}

@keyframes slideUp {
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.settings-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 2rem 2rem 1rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.settings-header h2 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
}

.close-btn {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  padding: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 6px;
  transition: all 0.2s ease;
}

.close-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  color: var(--white);
}

.settings-content {
  padding: 2rem;
}

.settings-description {
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
  margin-bottom: 2rem;
}

.settings-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-field {
  position: relative;
}

.form-label {
  display: block;
  margin-bottom: 0.5rem;
  color: var(--white);
  font-weight: 500;
  font-size: 0.9375rem;
}

.form-hint {
  display: block;
  font-size: 0.8125rem;
  font-weight: 400;
  color: rgba(255, 255, 255, 0.5);
  margin-top: 0.25rem;
}

.form-hint a {
  color: var(--primary-light);
  text-decoration: none;
}

.form-hint a:hover {
  text-decoration: underline;
}

.form-input {
  width: 100%;
  padding: 0.875rem 1rem;
  padding-right: 3rem;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: var(--white);
  font-size: 1rem;
  font-family: inherit;
  transition: all 0.2s ease;
}

.form-input:focus {
  outline: none;
  border-color: var(--primary);
  background: rgba(255, 255, 255, 0.05);
  box-shadow: 0 0 0 3px rgba(113, 59, 219, 0.1);
}

.toggle-password {
  position: absolute;
  right: 0.75rem;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.5);
  cursor: pointer;
  padding: 0.25rem;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 0.75rem;
}

.toggle-password:hover {
  color: var(--white);
}

.settings-actions {
  display: flex;
  gap: 1rem;
  margin-top: 0.5rem;
}

.settings-actions .btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.test-result {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem;
  border-radius: 8px;
  font-size: 0.9375rem;
}

.test-result.success {
  background: rgba(34, 197, 94, 0.1);
  border: 1px solid rgba(34, 197, 94, 0.3);
  color: #4ade80;
}

.test-result.error {
  background: rgba(239, 68, 68, 0.1);
  border: 1px solid rgba(239, 68, 68, 0.3);
  color: #f87171;
}

.settings-info {
  margin-top: 2rem;
  padding-top: 2rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.settings-info h3 {
  font-size: 1.125rem;
  margin-bottom: 1rem;
  color: var(--white);
}

.settings-info ol {
  margin: 0;
  padding-left: 1.5rem;
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.8;
}

.settings-info li {
  margin-bottom: 0.5rem;
}

.settings-info a {
  color: var(--primary-light);
  text-decoration: none;
}

.settings-info a:hover {
  text-decoration: underline;
}

@media (max-width: 768px) {
  .settings-overlay {
    padding: 1rem;
  }

  .settings-header,
  .settings-content {
    padding: 1.5rem;
  }

  .settings-actions {
    flex-direction: column;
  }
}
</style>
