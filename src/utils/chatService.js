// Сервис для работы с чатом и Telegram

// Используем относительные пути для работы через nginx proxy
// В dev режиме можно установить VITE_API_URL=http://localhost:3001
const API_URL = import.meta.env.VITE_API_URL || ''

let userId = null
let pollingStarted = false

// Генерируем или получаем ID пользователя
function getUserId() {
  if (!userId) {
    userId = localStorage.getItem('chat_user_id')
    if (!userId) {
      userId = `user_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
      localStorage.setItem('chat_user_id', userId)
    }
  }
  return userId
}

/**
 * Отправляет сообщение в чат
 */
export async function sendChatMessage(message) {
  const user = getUserId()
  
  try {
    const response = await fetch(`${API_URL}/api/chat/send`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        userId: user,
        message: message,
        timestamp: Date.now()
      }),
    })

    const data = await response.json()
    return data.success || false
  } catch (error) {
    console.error('Error sending chat message:', error)
    return false
  }
}

/**
 * Получает сообщения чата
 */
export async function getChatMessages() {
  const user = getUserId()
  
  try {
    const response = await fetch(`${API_URL}/api/chat/messages?userId=${user}`)
    const data = await response.json()
    
    if (data.success && data.messages) {
      return data.messages.map(msg => ({
        text: msg.text,
        isOutgoing: msg.userId === user,
        timestamp: msg.timestamp
      }))
    }
    
    return []
  } catch (error) {
    console.error('Error getting chat messages:', error)
    return []
  }
}

/**
 * Сохраняет данные пользователя (имя и телефон)
 */
export async function saveUserData(name, phone) {
  const user = getUserId()
  
  try {
    const response = await fetch(`${API_URL}/api/chat/user`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        userId: user,
        name: name,
        phone: phone
      }),
    })

    const data = await response.json()
    return data.success || false
  } catch (error) {
    console.error('Error saving user data:', error)
    return false
  }
}

/**
 * Запускает polling для получения ответов из Telegram
 */
export function startPolling() {
  if (pollingStarted) return
  
  pollingStarted = true
  
  // Polling будет выполняться на сервере
  // Фронтенд просто запрашивает новые сообщения
  console.log('Chat polling initialized')
}

