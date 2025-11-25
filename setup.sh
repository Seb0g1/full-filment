#!/bin/bash

# Скрипт первоначальной настройки проекта на сервере
# Выполните этот скрипт один раз при первой установке

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

log_info "🚀 Начинаем первоначальную настройку проекта..."

# Проверка Node.js
log_step "Проверка Node.js..."
if ! command -v node &> /dev/null; then
    log_error "Node.js не установлен!"
    log_info "Установите Node.js версии 18 или выше:"
    log_info "  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -"
    log_info "  sudo apt-get install -y nodejs"
    exit 1
fi

NODE_VERSION=$(node -v)
log_info "✅ Node.js установлен: $NODE_VERSION"

# Проверка npm
log_step "Проверка npm..."
if ! command -v npm &> /dev/null; then
    log_error "npm не установлен!"
    exit 1
fi

NPM_VERSION=$(npm -v)
log_info "✅ npm установлен: $NPM_VERSION"

# Установка PM2 глобально
log_step "Установка PM2 для управления процессами..."
if ! command -v pm2 &> /dev/null; then
    log_info "Устанавливаем PM2..."
    sudo npm install -g pm2
    log_info "✅ PM2 установлен"
else
    log_info "✅ PM2 уже установлен"
fi

# Настройка автозапуска PM2
log_step "Настройка автозапуска PM2..."
pm2 startup systemd -u $USER --hp $HOME || {
    log_warn "Не удалось настроить автозапуск PM2 автоматически"
    log_info "Выполните команду, которую вывел PM2, вручную"
}

# Создание папки для логов
log_step "Создание папки для логов..."
mkdir -p logs
log_info "✅ Папка logs создана"

# Проверка .env файлов
log_step "Проверка конфигурационных файлов..."

if [ ! -f "server/.env" ]; then
    log_warn "Файл server/.env не найден!"
    log_info "Создайте файл server/.env со следующим содержимым:"
    echo ""
    echo "TELEGRAM_BOT_TOKEN=ваш_токен_бота"
    echo "TELEGRAM_GROUP_CHAT_ID=ваш_chat_id"
    echo "PORT=3001"
    echo "TELEGRAM_TOPIC_CHAT_CLIENT=0"
    echo "TELEGRAM_TOPIC_CALCULATOR=0"
    echo "TELEGRAM_TOPIC_CONTACT_FORM=0"
    echo ""
    read -p "Нажмите Enter после создания файла..."
fi

if [ ! -f ".env" ]; then
    log_warn "Файл .env не найден в корне проекта!"
    log_info "Создайте файл .env со следующим содержимым (если нужно):"
    echo ""
    echo "VITE_API_URL=http://localhost:3001"
    echo ""
fi

# Установка зависимостей
log_step "Установка зависимостей..."
log_info "Устанавливаем зависимости для frontend..."
npm install

log_info "Устанавливаем зависимости для backend..."
cd server
npm install
cd ..

# Сборка проекта
log_step "Сборка frontend..."
npm run build
log_info "✅ Frontend собран"

# Настройка Nginx (опционально)
log_step "Настройка Nginx..."
if command -v nginx &> /dev/null; then
    log_info "Nginx найден. Хотите настроить конфигурацию? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        log_info "Скопируйте nginx.example.conf в /etc/nginx/sites-available/sakoo.ru"
        log_info "И обновите путь к проекту в конфигурации"
        log_info "Затем выполните:"
        log_info "  sudo ln -s /etc/nginx/sites-available/sakoo.ru /etc/nginx/sites-enabled/"
        log_info "  sudo nginx -t"
        log_info "  sudo systemctl reload nginx"
    fi
else
    log_warn "Nginx не найден. Установите nginx для обслуживания статики:"
    log_info "  sudo apt-get install nginx"
fi

log_info ""
log_info "✅ Первоначальная настройка завершена!"
log_info ""
log_info "Следующие шаги:"
log_info "1. Убедитесь, что файлы .env настроены правильно"
log_info "2. Настройте Nginx (если используете)"
log_info "3. Запустите деплой: ./deploy.sh"
log_info ""
log_info "Для управления процессами:"
log_info "  pm2 start ecosystem.config.js  # Запуск"
log_info "  pm2 stop fulfillment-bot       # Остановка"
log_info "  pm2 restart fulfillment-bot    # Перезапуск"
log_info "  pm2 logs fulfillment-bot       # Логи"

