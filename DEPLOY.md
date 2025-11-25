# Инструкция по деплою на сервер

## Быстрый старт

### 1. Первоначальная настройка на сервере

```bash
# Клонируйте репозиторий
git clone https://github.com/Seb0g1/full-filment.git
cd full-filment

# Запустите скрипт первоначальной настройки
chmod +x setup.sh
./setup.sh
```

### 2. Настройка переменных окружения

Создайте файл `server/.env`:

```env
TELEGRAM_BOT_TOKEN=ваш_токен_бота
TELEGRAM_GROUP_CHAT_ID=ваш_chat_id
PORT=3001
TELEGRAM_TOPIC_CHAT_CLIENT=0
TELEGRAM_TOPIC_CALCULATOR=0
TELEGRAM_TOPIC_CONTACT_FORM=0
```

### 3. Настройка Nginx

1. Скопируйте пример конфигурации:
```bash
sudo cp nginx.example.conf /etc/nginx/sites-available/sakoo.ru
```

2. Отредактируйте конфигурацию:
```bash
sudo nano /etc/nginx/sites-available/sakoo.ru
```

3. Обновите путь к проекту в конфигурации:
   - Найдите строку `root /path/to/your/project/dist;`
   - Замените на реальный путь, например: `root /home/user/full-filment/dist;`

4. Активируйте конфигурацию:
```bash
sudo ln -s /etc/nginx/sites-available/sakoo.ru /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 4. Автоматический деплой

После первоначальной настройки используйте скрипт для обновления:

```bash
./deploy.sh
```

Скрипт автоматически:
- ✅ Обновит проект с GitHub
- ✅ Установит зависимости
- ✅ Соберет frontend
- ✅ Перезапустит backend сервер

## Управление процессами

### PM2 команды

```bash
# Запуск
pm2 start ecosystem.config.js

# Остановка
pm2 stop fulfillment-bot

# Перезапуск
pm2 restart fulfillment-bot

# Просмотр логов
pm2 logs fulfillment-bot

# Статус
pm2 status

# Сохранить конфигурацию для автозапуска
pm2 save
```

### Автозапуск при перезагрузке сервера

```bash
pm2 startup systemd
pm2 save
```

## Настройка SSL (HTTPS)

```bash
# Установите certbot
sudo apt-get install certbot python3-certbot-nginx

# Получите сертификат
sudo certbot --nginx -d sakoo.ru -d www.sakoo.ru

# Автоматическое обновление
sudo certbot renew --dry-run
```

## Обновление проекта

Просто запустите:

```bash
./deploy.sh
```

Или вручную:

```bash
git pull origin main
npm install
cd server && npm install && cd ..
npm run build
pm2 restart fulfillment-bot
```

## Структура на сервере

```
/home/user/full-filment/
├── dist/                    # Собранный frontend (обслуживается Nginx)
├── server/                  # Backend сервер
│   ├── server.js
│   └── .env                 # Конфигурация (НЕ в git!)
├── deploy.sh                # Скрипт деплоя
├── setup.sh                 # Скрипт первоначальной настройки
└── ecosystem.config.js      # Конфигурация PM2
```

## Troubleshooting

### Backend не запускается

1. Проверьте логи:
```bash
pm2 logs fulfillment-bot
```

2. Проверьте .env файл:
```bash
cat server/.env
```

3. Проверьте, не занят ли порт:
```bash
sudo netstat -tulpn | grep 3001
```

### Frontend не отображается

1. Проверьте, что Nginx запущен:
```bash
sudo systemctl status nginx
```

2. Проверьте конфигурацию Nginx:
```bash
sudo nginx -t
```

3. Проверьте права доступа:
```bash
sudo chown -R www-data:www-data dist/
```

### Обновление не работает

1. Проверьте права на скрипт:
```bash
chmod +x deploy.sh
```

2. Проверьте, что вы в правильной директории:
```bash
pwd
```

3. Проверьте git статус:
```bash
git status
```

