<template>
  <div class="manager-chat-wrapper">
    <!-- Кнопка открытия чата -->
    <button 
      v-if="!isOpen" 
      @click="openChat"
      class="chat-toggle-btn glass"
      :class="{ 'has-unread': unreadCount > 0 }"
    >
      <MessageCircle :size="24" />
      <span v-if="unreadCount > 0" class="unread-badge">{{ unreadCount }}</span>
    </button>

    <!-- Окно чата -->
    <div v-if="isOpen" class="chat-window glass">
      <!-- Заголовок чата -->
      <div class="chat-header">
        <div class="chat-header-info">
          <div class="chat-avatar">
            <User :size="20" />
          </div>
          <div>
            <h3 class="chat-title">Чат с менеджером</h3>
            <p class="chat-status" :class="{ online: isManagerOnline }">
              {{ isManagerOnline ? 'Онлайн' : 'Офлайн' }}
            </p>
          </div>
        </div>
        <button @click="closeChat" class="chat-close-btn">
          <X :size="20" />
        </button>
      </div>

      <!-- Форма ввода данных пользователя -->
      <div v-if="!userDataSaved" class="chat-user-form">
        <div class="user-form-content">
          <h4>Представьтесь, пожалуйста</h4>
          <p class="user-form-subtitle">Для начала общения укажите ваше имя и номер телефона</p>
          <form @submit.prevent="saveUserDataHandler" class="user-form">
            <div class="form-field">
              <label for="user-name">Ваше имя</label>
              <input
                id="user-name"
                v-model="userName"
                type="text"
                placeholder="Иван"
                class="form-input"
                required
                :disabled="isSavingUserData"
              />
            </div>
            <div class="form-field">
              <label for="user-phone">Номер телефона</label>
              <input
                id="user-phone"
                v-model="userPhone"
                type="tel"
                placeholder="+7 (999) 123-45-67"
                class="form-input"
                required
                :disabled="isSavingUserData"
              />
            </div>
            <button 
              type="submit" 
              class="btn-submit-user"
              :disabled="!userName.trim() || !userPhone.trim() || isSavingUserData"
            >
              <Loader2 v-if="isSavingUserData" :size="18" class="spinner" />
              <span v-else>Начать общение</span>
            </button>
          </form>
        </div>
      </div>

      <!-- Сообщения -->
      <div v-else class="chat-messages" ref="messagesContainer">
        <div v-if="messages.length === 0" class="chat-empty">
          <MessageCircle :size="48" class="empty-icon" />
          <p>Начните диалог с менеджером</p>
        </div>
        <div
          v-for="(message, index) in messages"
          :key="index"
          class="chat-message"
          :class="{ 'message-outgoing': message.isOutgoing, 'message-incoming': !message.isOutgoing }"
        >
          <div class="message-content">
            <p>{{ message.text }}</p>
            <span class="message-time">{{ formatTime(message.timestamp) }}</span>
          </div>
        </div>
        <div v-if="isTyping" class="chat-message message-incoming">
          <div class="message-content typing-indicator">
            <div class="typing-dots">
              <span></span>
              <span></span>
              <span></span>
            </div>
          </div>
        </div>
      </div>

      <!-- Форма ввода -->
      <div v-if="userDataSaved" class="chat-input-wrapper">
        <form @submit.prevent="sendMessage" class="chat-input-form">
          <input
            v-model="inputMessage"
            type="text"
            placeholder="Введите сообщение..."
            class="chat-input"
            :disabled="isSending || !userDataSaved"
          />
          <button 
            type="submit" 
            class="chat-send-btn"
            :disabled="!inputMessage.trim() || isSending || !userDataSaved"
          >
            <Send :size="20" />
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick, watch } from 'vue'
import { MessageCircle, X, Send, User, Loader2 } from 'lucide-vue-next'
import { sendChatMessage, getChatMessages, startPolling, saveUserData } from '../utils/chatService'

const isOpen = ref(false)
const messages = ref([])
const inputMessage = ref('')
const isSending = ref(false)
const isTyping = ref(false)
const isManagerOnline = ref(true)
const unreadCount = ref(0)
const messagesContainer = ref(null)
const pollingInterval = ref(null)

// Данные пользователя
const userDataSaved = ref(false)
const userName = ref('')
const userPhone = ref('')
const isSavingUserData = ref(false)

const openChat = () => {
  isOpen.value = true
  unreadCount.value = 0
  
  // Проверяем, сохранены ли данные пользователя
  const savedName = localStorage.getItem('chat_user_name')
  const savedPhone = localStorage.getItem('chat_user_phone')
  
  if (savedName && savedPhone) {
    userDataSaved.value = true
    userName.value = savedName
    userPhone.value = savedPhone
    scrollToBottom()
  } else {
    userDataSaved.value = false
  }
}

const closeChat = () => {
  isOpen.value = false
}

const formatTime = (timestamp) => {
  const date = new Date(timestamp)
  return date.toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' })
}

const scrollToBottom = async () => {
  await nextTick()
  if (messagesContainer.value) {
    messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
  }
}

const sendMessage = async () => {
  if (!inputMessage.value.trim() || isSending.value) return

  const messageText = inputMessage.value.trim()
  inputMessage.value = ''

  // Добавляем сообщение локально
  const newMessage = {
    text: messageText,
    isOutgoing: true,
    timestamp: Date.now()
  }
  messages.value.push(newMessage)
  scrollToBottom()

  isSending.value = true
  isTyping.value = true

  try {
    // Отправляем сообщение на сервер
    const success = await sendChatMessage(messageText)
    
    if (!success) {
      // Если отправка не удалась, показываем ошибку
      messages.value.pop()
      messages.value.push({
        text: 'Ошибка отправки сообщения. Попробуйте позже.',
        isOutgoing: true,
        timestamp: Date.now(),
        isError: true
      })
    }
  } catch (error) {
    console.error('Error sending message:', error)
    messages.value.pop()
    messages.value.push({
      text: 'Ошибка отправки сообщения. Попробуйте позже.',
      isOutgoing: true,
      timestamp: Date.now(),
      isError: true
    })
  } finally {
    isSending.value = false
    isTyping.value = false
  }
}

const loadMessages = async () => {
  try {
    const chatMessages = await getChatMessages()
    if (chatMessages && chatMessages.length > 0) {
      messages.value = chatMessages
      scrollToBottom()
    }
  } catch (error) {
    console.error('Error loading messages:', error)
  }
}

const checkNewMessages = async () => {
  try {
    const chatMessages = await getChatMessages()
    if (chatMessages && chatMessages.length > messages.value.length) {
      const newMessages = chatMessages.slice(messages.value.length)
      messages.value = chatMessages
      
      // Увеличиваем счетчик непрочитанных, если чат закрыт
      if (!isOpen.value) {
        unreadCount.value += newMessages.filter(m => !m.isOutgoing).length
      }
      
      scrollToBottom()
    }
  } catch (error) {
    console.error('Error checking messages:', error)
  }
}

onMounted(async () => {
  await loadMessages()
  
  // Запускаем polling для получения новых сообщений
  pollingInterval.value = setInterval(checkNewMessages, 3000) // Проверяем каждые 3 секунды
  
  // Запускаем polling на сервере для получения ответов из Telegram
  startPolling()
})

onUnmounted(() => {
  if (pollingInterval.value) {
    clearInterval(pollingInterval.value)
  }
})

const saveUserDataHandler = async () => {
  if (!userName.value.trim() || !userPhone.value.trim()) return

  isSavingUserData.value = true

  try {
    const success = await saveUserData(userName.value.trim(), userPhone.value.trim())
    
    if (success) {
      userDataSaved.value = true
      localStorage.setItem('chat_user_name', userName.value.trim())
      localStorage.setItem('chat_user_phone', userPhone.value.trim())
      scrollToBottom()
    } else {
      alert('Ошибка при сохранении данных. Попробуйте еще раз.')
    }
  } catch (error) {
    console.error('Error saving user data:', error)
    alert('Ошибка при сохранении данных. Попробуйте еще раз.')
  } finally {
    isSavingUserData.value = false
  }
}

watch(isOpen, (newValue) => {
  if (newValue) {
    if (userDataSaved.value) {
      scrollToBottom()
    }
    unreadCount.value = 0
  }
})
</script>

<style scoped>
.manager-chat-wrapper {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  z-index: 9999;
  font-family: inherit;
}

.chat-toggle-btn {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  border: none;
  background: var(--gradient-primary);
  color: var(--white);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: var(--shadow-lg);
  transition: all 0.3s ease;
  position: relative;
}

.chat-toggle-btn:hover {
  transform: scale(1.1);
  box-shadow: var(--shadow-xl);
}

.chat-toggle-btn.has-unread {
  animation: pulse 2s infinite;
}

.unread-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  background: var(--accent-red);
  color: var(--white);
  border-radius: 50%;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  font-weight: 600;
  border: 2px solid var(--dark);
}

.chat-window {
  width: 380px;
  height: 600px;
  display: flex;
  flex-direction: column;
  background: rgba(26, 21, 37, 0.95);
  backdrop-filter: blur(20px) saturate(150%);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  box-shadow: 
    0 20px 60px rgba(0, 0, 0, 0.3),
    0 0 0 1px rgba(99, 102, 241, 0.1);
  overflow: hidden;
}

.chat-header {
  padding: 1.25rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: rgba(99, 102, 241, 0.05);
}

.chat-header-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.chat-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: var(--gradient-primary);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--white);
}

.chat-title {
  font-size: 1rem;
  font-weight: 600;
  margin: 0;
  color: var(--white);
}

.chat-status {
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.5);
  margin: 0;
}

.chat-status.online {
  color: #10b981;
}

.chat-close-btn {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: none;
  background: transparent;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}

.chat-close-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  color: var(--white);
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 1.25rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.chat-messages::-webkit-scrollbar {
  width: 6px;
}

.chat-messages::-webkit-scrollbar-track {
  background: transparent;
}

.chat-messages::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.chat-messages::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

.chat-empty {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: rgba(255, 255, 255, 0.5);
  text-align: center;
  padding: 2rem;
}

.empty-icon {
  margin-bottom: 1rem;
  opacity: 0.5;
}

.chat-message {
  display: flex;
  max-width: 75%;
  animation: slideIn 0.3s ease;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.message-outgoing {
  align-self: flex-end;
  margin-left: auto;
}

.message-incoming {
  align-self: flex-start;
}

.message-content {
  padding: 0.75rem 1rem;
  border-radius: 16px;
  position: relative;
}

.message-outgoing .message-content {
  background: var(--gradient-primary);
  color: var(--white);
  border-bottom-right-radius: 4px;
}

.message-incoming .message-content {
  background: rgba(255, 255, 255, 0.1);
  color: var(--white);
  border-bottom-left-radius: 4px;
}

.message-content p {
  margin: 0 0 0.25rem 0;
  word-wrap: break-word;
}

.message-time {
  font-size: 0.7rem;
  opacity: 0.7;
  display: block;
  margin-top: 0.25rem;
}

.typing-indicator {
  padding: 0.75rem 1rem;
}

.typing-dots {
  display: flex;
  gap: 4px;
  align-items: center;
}

.typing-dots span {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.5);
  animation: typing 1.4s infinite;
}

.typing-dots span:nth-child(2) {
  animation-delay: 0.2s;
}

.typing-dots span:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes typing {
  0%, 60%, 100% {
    transform: translateY(0);
    opacity: 0.5;
  }
  30% {
    transform: translateY(-8px);
    opacity: 1;
  }
}

.chat-input-wrapper {
  padding: 1rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  background: rgba(99, 102, 241, 0.05);
}

.chat-input-form {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.chat-input {
  flex: 1;
  padding: 0.75rem 1rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.05);
  color: var(--white);
  font-size: 0.9rem;
  outline: none;
  transition: all 0.2s ease;
}

.chat-input:focus {
  border-color: var(--primary);
  background: rgba(255, 255, 255, 0.08);
}

.chat-input::placeholder {
  color: rgba(255, 255, 255, 0.4);
}

.chat-input:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.chat-send-btn {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  border: none;
  background: var(--gradient-primary);
  color: var(--white);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.chat-send-btn:hover:not(:disabled) {
  transform: scale(1.05);
  box-shadow: var(--shadow-md);
}

.chat-send-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
}

.chat-user-form {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}

.user-form-content {
  width: 100%;
  max-width: 320px;
}

.user-form-content h4 {
  font-size: 1.25rem;
  font-weight: 600;
  margin: 0 0 0.5rem 0;
  color: var(--white);
  text-align: center;
}

.user-form-subtitle {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.6);
  margin: 0 0 1.5rem 0;
  text-align: center;
}

.user-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.user-form .form-field {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.user-form label {
  font-size: 0.875rem;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.8);
}

.user-form .form-input {
  padding: 0.75rem 1rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.05);
  color: var(--white);
  font-size: 0.9rem;
  outline: none;
  transition: all 0.2s ease;
}

.user-form .form-input:focus {
  border-color: var(--primary);
  background: rgba(255, 255, 255, 0.08);
}

.user-form .form-input::placeholder {
  color: rgba(255, 255, 255, 0.4);
}

.user-form .form-input:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-submit-user {
  padding: 0.875rem 1.5rem;
  border: none;
  border-radius: 12px;
  background: var(--gradient-primary);
  color: var(--white);
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  transition: all 0.2s ease;
  margin-top: 0.5rem;
}

.btn-submit-user:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
}

.btn-submit-user:disabled {
  opacity: 0.5;
  cursor: not-allowed;
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

@media (max-width: 768px) {
  .manager-chat-wrapper {
    bottom: 1rem;
    right: 1rem;
  }

  .chat-window {
    width: calc(100vw - 2rem);
    height: calc(100vh - 2rem);
    max-height: 600px;
  }

  .chat-toggle-btn {
    width: 56px;
    height: 56px;
  }
}
</style>

