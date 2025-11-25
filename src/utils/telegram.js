// Утилита для отправки сообщений в Telegram бота

const STORAGE_KEY_TOKEN = 'telegram_bot_token'
const STORAGE_KEY_CHAT_ID = 'telegram_chat_id'

/**
 * Получает настройки Telegram из localStorage
 */
export function getTelegramConfig() {
  const token = localStorage.getItem(STORAGE_KEY_TOKEN) || import.meta.env.VITE_TELEGRAM_BOT_TOKEN || ''
  const chatId = localStorage.getItem(STORAGE_KEY_CHAT_ID) || import.meta.env.VITE_TELEGRAM_CHAT_ID || ''
  return { token, chatId }
}

/**
 * Сохраняет настройки Telegram в localStorage
 */
export function saveTelegramConfig(token, chatId) {
  if (token) localStorage.setItem(STORAGE_KEY_TOKEN, token)
  if (chatId) localStorage.setItem(STORAGE_KEY_CHAT_ID, chatId)
}

/**
 * Проверяет валидность настроек Telegram
 */
export async function testTelegramConfig(token, chatId) {
  if (!token || !chatId) return { success: false, error: 'Заполните все поля' }

  try {
    const url = `https://api.telegram.org/bot${token}/sendMessage`
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        chat_id: chatId,
        text: '✅ Тест подключения. Бот настроен корректно!',
        parse_mode: 'HTML',
      }),
    })

    const data = await response.json()
    
    if (data.ok) {
      return { success: true }
    } else {
      return { success: false, error: data.description || 'Ошибка при отправке сообщения' }
    }
  } catch (error) {
    return { success: false, error: 'Ошибка подключения к Telegram API' }
  }
}

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001'

/**
 * Отправляет сообщение в Telegram бота через backend API
 * @param {string} message - Текст сообщения
 * @param {string} type - Тип сообщения: 'calculator' | 'contact' | 'default'
 * @returns {Promise<boolean>} - Успешность отправки
 */
export async function sendTelegramMessage(message, type = 'default') {
  try {
    let endpoint = '/api/telegram/calculator'
    
    if (type === 'contact') {
      endpoint = '/api/telegram/contact'
    } else if (type === 'calculator') {
      endpoint = '/api/telegram/calculator'
    } else {
      // Для обратной совместимости используем старый метод
      const { token, chatId } = getTelegramConfig()
      
      if (!token || !chatId) {
        console.error('Telegram credentials not configured')
        return false
      }

      const url = `https://api.telegram.org/bot${token}/sendMessage`
      
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          chat_id: chatId,
          text: message,
          parse_mode: 'HTML',
        }),
      })

      const data = await response.json()
      
      if (data.ok) {
        return true
      } else {
        console.error('Telegram API error:', data)
        return false
      }
    }

    // Используем новый backend API
    const response = await fetch(`${API_URL}${endpoint}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: message
      }),
    })

    const data = await response.json()
    return data.success || false
  } catch (error) {
    console.error('Error sending to Telegram:', error)
    return false
  }
}

/**
 * Форматирует контактную информацию в зависимости от способа связи
 */
function formatContactInfo(formData) {
  const method = formData.contactMethod
  
  if (method === 'email') {
    return `📧 Email: ${formData.email || 'Не указано'}`
  } else if (method === 'telegram') {
    const telegramInfo = formData.telegramTag && formData.telegramTag.trim() 
      ? `💬 Telegram: ${formData.telegramTag.trim()}` 
      : '💬 Telegram: не указан'
    return `${telegramInfo}\n📞 Телефон: ${formData.phone || 'Не указано'}`
  } else if (method === 'phone') {
    return `📞 Телефон: ${formData.phone || 'Не указано'}`
  } else if (method === 'whatsapp') {
    return `📱 WhatsApp: ${formData.phone || 'Не указано'}`
  } else if (method === 'viber') {
    return `💜 Viber: ${formData.phone || 'Не указано'}`
  } else {
    return `📞 Контакт: ${formData.phone || 'Не указано'}`
  }
}

/**
 * Форматирует данные калькулятора в сообщение
 */
export function formatCalculatorMessage(formData) {
  const marketplaces = formData.marketplaces.length > 0 
    ? formData.marketplaces.join(', ') 
    : 'Не указано'
  
  // Маппинг способов связи
  const contactMethodMap = {
    'phone': 'Телефон',
    'telegram': 'Телеграм',
    'whatsapp': 'WhatsApp',
    'viber': 'Viber',
    'email': 'Email'
  }
  
  const contactMethod = formData.contactMethod 
    ? contactMethodMap[formData.contactMethod] || formData.contactMethod
    : 'Не указано'
  
  // Маппинг объемов заказов
  const orderVolumeMap = {
    '50000': '50000',
    '100000': '100000',
    '250000': '250000',
    '500000': '500000',
    '1000000': '1000000+'
  }
  
  const orderVolume = formData.orderVolume 
    ? orderVolumeMap[formData.orderVolume] || formData.orderVolume
    : 'Не указано'
  
  // Маппинг сроков аренды
  const rentalPeriodMap = {
    '1': 'До 1 месяца',
    '3': 'До 3-х месяцев',
    '6': 'До 6 месяцев',
    '12': 'До 1 года',
    '12+': 'Свыше 1 года'
  }
  
  const rentalPeriod = formData.rentalPeriod 
    ? rentalPeriodMap[formData.rentalPeriod] || formData.rentalPeriod
    : 'Не указано'
  
  // Формируем строку региона и города
  const region = formData.region || ''
  const city = formData.city || ''
  const regionCity = region 
    ? (city ? `${region}, ${city}` : region)
    : 'Не указано'
  
  return `📊 Новая заявка с калькулятора

Маркетплейсы: ${marketplaces}

-----------------------------

Направление бизнеса: ${formData.businessType || 'Не указано'}

-------------------------------

Объем заказов: ${orderVolume}

-------------------------------

Регион: ${regionCity}

-------------------------------

Срок аренды: ${rentalPeriod}

-------------------------------

Способ связи: ${contactMethod}

-------------------------------

Контактные данные:

👤 Имя: ${formData.name}

${formatContactInfo(formData)}
`.trim()
}

/**
 * Форматирует данные контактной формы в сообщение
 */
export function formatContactMessage(formData) {
  return `
<b>📝 Новая заявка с контактной формы</b>

<b>Имя:</b> ${formData.name}
<b>Телефон:</b> ${formData.phone}
${formData.message ? `<b>Сообщение:</b>\n${formData.message}` : ''}

<b>Время:</b> ${new Date().toLocaleString('ru-RU')}
  `.trim()
}

