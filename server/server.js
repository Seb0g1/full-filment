import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import TelegramBot from 'node-telegram-bot-api'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

// Загружаем .env файл из папки server
dotenv.config({ path: join(__dirname, '.env') })

const app = express()
const PORT = process.env.PORT || 3001

// Middleware
app.use(cors())
app.use(express.json())

// Хранилище сообщений (в продакшене использовать БД)
const messages = new Map() // userId -> messages[]
const userTelegramMap = new Map() // userId -> { messageId, threadId, lastBotMessageId, botMessageIds: [] }
const userInfo = new Map() // userId -> { name, phone }

// Настройка Telegram бота
const BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || ''
const GROUP_CHAT_ID = process.env.TELEGRAM_GROUP_CHAT_ID || ''

// ID топиков в группе
const TOPIC_CHAT_CLIENT = parseInt(process.env.TELEGRAM_TOPIC_CHAT_CLIENT || '0')
const TOPIC_CALCULATOR = parseInt(process.env.TELEGRAM_TOPIC_CALCULATOR || '0')
const TOPIC_CONTACT_FORM = parseInt(process.env.TELEGRAM_TOPIC_CONTACT_FORM || '0')

if (!BOT_TOKEN || !GROUP_CHAT_ID) {
  console.warn('⚠️  Telegram bot token or group chat ID not configured!')
  console.warn('   Set TELEGRAM_BOT_TOKEN and TELEGRAM_GROUP_CHAT_ID in .env file')
}

let bot = null
if (BOT_TOKEN) {
  try {
    bot = new TelegramBot(BOT_TOKEN, { polling: true })

    // Обработка ошибок бота
    bot.on('error', (error) => {
      console.error('❌ Telegram bot error:', error.message)
    })

    bot.on('polling_error', (error) => {
      console.error('❌ Telegram polling error:', error.message)
      if (error.code === 'ETELEGRAM' && error.response?.body?.error_code === 401) {
        console.error('⚠️  Invalid bot token! Please check TELEGRAM_BOT_TOKEN in .env file')
      }
    })

    // Обработка ответов из Telegram группы
    bot.on('message', async (msg) => {
    // Игнорируем сообщения от бота
    if (msg.from.is_bot) return

    // Проверяем, что сообщение из нужной группы
    if (msg.chat.id.toString() !== GROUP_CHAT_ID.toString()) return

    // Проверяем, является ли это ответом на сообщение
    if (msg.reply_to_message) {
      const repliedMessage = msg.reply_to_message
      const repliedMessageId = repliedMessage.message_id
      
      // Проверяем, является ли это ответом на сообщение от бота
      if (repliedMessage.from && repliedMessage.from.is_bot) {
        // Находим пользователя по ID сообщения бота в Telegram
        // Проверяем все сообщения бота в цепочке для каждого пользователя
        for (const [userId, telegramData] of userTelegramMap.entries()) {
          // Проверяем, является ли repliedMessageId одним из сообщений нашего бота
          const botMessageIds = telegramData.botMessageIds || []
          const isBotMessage = 
            telegramData.lastBotMessageId === repliedMessageId ||
            telegramData.messageId === repliedMessageId ||
            botMessageIds.includes(repliedMessageId)
          
          if (isBotMessage) {
            // Сохраняем ответ менеджера
            if (!messages.has(userId)) {
              messages.set(userId, [])
            }
            
            const userMessages = messages.get(userId)
            userMessages.push({
              text: msg.text,
              isOutgoing: false,
              timestamp: msg.date * 1000,
              fromTelegram: true
            })
            
            messages.set(userId, userMessages)
            
            // НЕ обновляем lastBotMessageId - оставляем его указывающим на последнее сообщение бота
            // чтобы следующее сообщение клиента отвечало на последнее сообщение бота
            
            console.log(`✅ Ответ от менеджера для пользователя ${userId}`)
            break
          }
        }
      }
    }
    })

    console.log('✅ Telegram bot initialized')
  } catch (error) {
    console.error('❌ Failed to initialize Telegram bot:', error.message)
    console.error('   Please check your TELEGRAM_BOT_TOKEN in .env file')
    bot = null
  }
} else {
  console.warn('⚠️  Telegram bot not initialized - no token provided')
  console.warn('   Create .env file in server/ folder with TELEGRAM_BOT_TOKEN and TELEGRAM_GROUP_CHAT_ID')
}

// Форматирование сообщения для Telegram
function formatChatMessage(userId, userName, userPhone, message, isFirst = false) {
  let text = ''
  if (isFirst) {
    text = `💬 <b>Новый чат с клиентом</b>\n\n`
    text += `👤 <b>Имя:</b> ${userName}\n`
    text += `📞 <b>Телефон:</b> ${userPhone}\n`
    text += `🆔 <b>ID:</b> <code>${userId}</code>\n\n`
    text += `─────────────────\n\n`
  }
  text += `💬 <b>Сообщение от клиента:</b>\n${message}`
  return text
}

function formatManagerReply(replyText, userName) {
  return `✅ <b>Ответ менеджера для ${userName}:</b>\n${replyText}`
}

// API: Сохранение данных пользователя
app.post('/api/chat/user', (req, res) => {
  try {
    const { userId, name, phone } = req.body

    if (!userId || !name || !phone) {
      return res.status(400).json({ success: false, error: 'Missing userId, name or phone' })
    }

    userInfo.set(userId, { name, phone })
    res.json({ success: true })
  } catch (error) {
    console.error('Error in /api/chat/user:', error)
    res.status(500).json({ success: false, error: 'Internal server error' })
  }
})

// API: Отправка сообщения
app.post('/api/chat/send', async (req, res) => {
  try {
    const { userId, message, timestamp } = req.body

    if (!userId || !message) {
      return res.status(400).json({ success: false, error: 'Missing userId or message' })
    }

    // Получаем информацию о пользователе
    const info = userInfo.get(userId) || { name: 'Клиент', phone: 'Не указан' }

    // Сохраняем сообщение локально
    if (!messages.has(userId)) {
      messages.set(userId, [])
    }

    const userMessages = messages.get(userId)
    const isFirstMessage = userMessages.length === 0
    
    userMessages.push({
      text: message,
      isOutgoing: true,
      timestamp: timestamp || Date.now(),
      userId: userId
    })
    messages.set(userId, userMessages)

    // Отправляем сообщение в Telegram группу в топик "Чат с клиентом"
    if (bot && GROUP_CHAT_ID) {
      try {
        let telegramData = userTelegramMap.get(userId)
        
        // Если это первое сообщение, создаем новую цепочку
        if (!telegramData || isFirstMessage) {
          const formattedMessage = formatChatMessage(userId, info.name, info.phone, message, true)
          
          const telegramMessage = await bot.sendMessage(
            GROUP_CHAT_ID,
            formattedMessage,
            {
              message_thread_id: TOPIC_CHAT_CLIENT || undefined,
              parse_mode: 'HTML'
            }
          )

          // Сохраняем связь между userId и telegram message ID
          telegramData = {
            messageId: telegramMessage.message_id,
            threadId: TOPIC_CHAT_CLIENT || undefined,
            lastBotMessageId: telegramMessage.message_id,
            botMessageIds: [telegramMessage.message_id] // Массив всех message_id сообщений бота
          }
          userTelegramMap.set(userId, telegramData)
        } else {
          // Последующие сообщения - отвечаем на последнее сообщение бота
          const formattedMessage = formatChatMessage(userId, info.name, info.phone, message, false)
          
          const telegramMessage = await bot.sendMessage(
            GROUP_CHAT_ID,
            formattedMessage,
            {
              message_thread_id: telegramData.threadId,
              parse_mode: 'HTML',
              reply_to_message_id: telegramData.lastBotMessageId
            }
          )

          // Обновляем последнее сообщение бота и добавляем в массив
          telegramData.lastBotMessageId = telegramMessage.message_id
          if (!telegramData.botMessageIds) {
            telegramData.botMessageIds = []
          }
          telegramData.botMessageIds.push(telegramMessage.message_id)
          userTelegramMap.set(userId, telegramData)
        }

        console.log(`📤 Сообщение отправлено в Telegram для пользователя ${userId}`)
      } catch (error) {
        console.error('❌ Error sending to Telegram:', error.message)
        if (error.response?.body?.error_code === 400) {
          console.error('   Возможно, бот не добавлен в группу или неправильный GROUP_CHAT_ID')
        } else if (error.response?.body?.error_code === 401) {
          console.error('   Неверный токен бота! Проверьте TELEGRAM_BOT_TOKEN')
        } else if (error.response?.body?.error_code === 403) {
          console.error('   Бот заблокирован или не имеет доступа к группе')
        }
        // Продолжаем работу даже если Telegram недоступен
      }
    }

    res.json({ success: true })
  } catch (error) {
    console.error('Error in /api/chat/send:', error)
    res.status(500).json({ success: false, error: 'Internal server error' })
  }
})

// API: Получение сообщений
app.get('/api/chat/messages', (req, res) => {
  try {
    const { userId } = req.query

    if (!userId) {
      return res.status(400).json({ success: false, error: 'Missing userId' })
    }

    const userMessages = messages.get(userId) || []
    res.json({ success: true, messages: userMessages })
  } catch (error) {
    console.error('Error in /api/chat/messages:', error)
    res.status(500).json({ success: false, error: 'Internal server error' })
  }
})

// API: Отправка заявки с калькулятора
app.post('/api/telegram/calculator', async (req, res) => {
  try {
    const { message } = req.body

    if (!message) {
      return res.status(400).json({ success: false, error: 'Missing message' })
    }

    if (bot && GROUP_CHAT_ID) {
      try {
        await bot.sendMessage(
          GROUP_CHAT_ID,
          message,
          {
            message_thread_id: TOPIC_CALCULATOR || undefined,
            parse_mode: 'HTML'
          }
        )
        console.log('📊 Заявка с калькулятора отправлена в Telegram')
      } catch (error) {
        console.error('❌ Error sending calculator message:', error.message)
        if (error.response?.body?.error_code === 400) {
          console.error('   Возможно, бот не добавлен в группу или неправильный GROUP_CHAT_ID')
        } else if (error.response?.body?.error_code === 401) {
          console.error('   Неверный токен бота! Проверьте TELEGRAM_BOT_TOKEN')
        }
        return res.status(500).json({ 
          success: false, 
          error: 'Failed to send to Telegram',
          details: error.message 
        })
      }
    }

    res.json({ success: true })
  } catch (error) {
    console.error('Error in /api/telegram/calculator:', error)
    res.status(500).json({ success: false, error: 'Internal server error' })
  }
})

// API: Отправка заявки с контактной формы
app.post('/api/telegram/contact', async (req, res) => {
  try {
    const { message } = req.body

    if (!message) {
      return res.status(400).json({ success: false, error: 'Missing message' })
    }

    if (bot && GROUP_CHAT_ID) {
      try {
        await bot.sendMessage(
          GROUP_CHAT_ID,
          message,
          {
            message_thread_id: TOPIC_CONTACT_FORM || undefined,
            parse_mode: 'HTML'
          }
        )
        console.log('📝 Заявка с контактной формы отправлена в Telegram')
      } catch (error) {
        console.error('❌ Error sending contact message:', error.message)
        if (error.response?.body?.error_code === 400) {
          console.error('   Возможно, бот не добавлен в группу или неправильный GROUP_CHAT_ID')
        } else if (error.response?.body?.error_code === 401) {
          console.error('   Неверный токен бота! Проверьте TELEGRAM_BOT_TOKEN')
        }
        return res.status(500).json({ 
          success: false, 
          error: 'Failed to send to Telegram',
          details: error.message 
        })
      }
    }

    res.json({ success: true })
  } catch (error) {
    console.error('Error in /api/telegram/contact:', error)
    res.status(500).json({ success: false, error: 'Internal server error' })
  }
})

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', telegramConfigured: !!BOT_TOKEN && !!GROUP_CHAT_ID })
})

app.listen(PORT, () => {
  console.log('\n' + '='.repeat(50))
  console.log(`🚀 Chat server running on http://localhost:${PORT}`)
  console.log('='.repeat(50))
  console.log(`📱 Telegram bot: ${BOT_TOKEN ? '✅ Configured' : '❌ Not configured'}`)
  if (!BOT_TOKEN) {
    console.log('   ⚠️  Create .env file in server/ folder with TELEGRAM_BOT_TOKEN')
  }
  console.log(`👥 Group chat ID: ${GROUP_CHAT_ID || '❌ Not set'}`)
  if (!GROUP_CHAT_ID) {
    console.log('   ⚠️  Set TELEGRAM_GROUP_CHAT_ID in .env file')
  }
  console.log(`📌 Topics configured:`)
  console.log(`   - Чат с клиентом: ${TOPIC_CHAT_CLIENT || 'Not set (using 0)'}`)
  console.log(`   - Калькулятор заявки: ${TOPIC_CALCULATOR || 'Not set (using 0)'}`)
  console.log(`   - Оставить заявку: ${TOPIC_CONTACT_FORM || 'Not set (using 0)'}`)
  if (BOT_TOKEN && GROUP_CHAT_ID) {
    console.log('\n✅ Telegram bot is ready to receive messages!')
  } else {
    console.log('\n⚠️  Telegram bot is NOT configured. Messages will not be sent to Telegram.')
    console.log('   See CHAT_SETUP.md or server/README.md for setup instructions')
  }
  console.log('='.repeat(50) + '\n')
})

