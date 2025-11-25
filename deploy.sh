#!/bin/bash

# Скрипт автоматического деплоя проекта
# Обновляет проект с GitHub, устанавливает зависимости, собирает и запускает

set -e  # Остановка при ошибке

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Проверка наличия git
if ! command -v git &> /dev/null; then
    log_error "Git не установлен. Установите git: sudo apt-get install git"
    exit 1
fi

# Проверка наличия node
if ! command -v node &> /dev/null; then
    log_error "Node.js не установлен. Установите Node.js: https://nodejs.org/"
    exit 1
fi

# Проверка наличия npm
if ! command -v npm &> /dev/null; then
    log_error "npm не установлен. Установите npm вместе с Node.js"
    exit 1
fi

log_info "Начинаем деплой проекта..."

# Получаем текущую ветку
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
log_info "Текущая ветка: $CURRENT_BRANCH"

# Обновление с GitHub
log_info "Обновляем проект с GitHub..."
git fetch origin
git pull origin $CURRENT_BRANCH || {
    log_warn "Не удалось обновить с GitHub. Продолжаем с текущей версией..."
}

# Установка зависимостей для frontend
log_info "Устанавливаем зависимости для frontend..."
npm install

# Установка зависимостей для backend
log_info "Устанавливаем зависимости для backend..."
cd server
npm install
cd ..

# Сборка frontend
log_info "Собираем frontend для production..."
npm run build

# Проверка наличия PM2
if command -v pm2 &> /dev/null; then
    log_info "PM2 найден. Используем PM2 для управления процессами..."
    
    # Останавливаем старые процессы
    log_info "Останавливаем старые процессы..."
    pm2 stop fulfillment-bot 2>/dev/null || true
    pm2 delete fulfillment-bot 2>/dev/null || true
    
    # Запускаем backend сервер через PM2
    log_info "Запускаем backend сервер через PM2..."
    cd server
    pm2 start server.js --name fulfillment-bot --env production
    pm2 save
    cd ..
    
    log_info "✅ Backend сервер запущен через PM2"
    log_info "Проверить статус: pm2 status"
    log_info "Посмотреть логи: pm2 logs fulfillment-bot"
else
    log_warn "PM2 не найден. Запускаем backend сервер напрямую..."
    log_warn "Рекомендуется установить PM2: npm install -g pm2"
    
    # Проверяем, не запущен ли уже процесс
    if pgrep -f "node.*server.js" > /dev/null; then
        log_warn "Backend сервер уже запущен. Останавливаем старый процесс..."
        pkill -f "node.*server.js"
        sleep 2
    fi
    
    # Запускаем backend сервер в фоне
    log_info "Запускаем backend сервер..."
    cd server
    nohup node server.js > ../server.log 2>&1 &
    echo $! > ../server.pid
    cd ..
    
    log_info "✅ Backend сервер запущен (PID: $(cat server.pid))"
    log_info "Логи: tail -f server.log"
fi

# Проверка конфигурации nginx (если используется)
if command -v nginx &> /dev/null; then
    log_info "Проверяем конфигурацию nginx..."
    
    # Путь к конфигурации nginx (может отличаться)
    NGINX_CONF="/etc/nginx/sites-available/sakoo.ru"
    
    if [ -f "$NGINX_CONF" ]; then
        log_info "Проверяем синтаксис nginx конфигурации..."
        sudo nginx -t && {
            log_info "Перезагружаем nginx..."
            sudo systemctl reload nginx || sudo service nginx reload
            log_info "✅ Nginx перезагружен"
        } || {
            log_error "Ошибка в конфигурации nginx!"
        }
    else
        log_warn "Конфигурация nginx не найдена по пути: $NGINX_CONF"
        log_warn "Создайте конфигурацию для домена sakoo.ru"
    fi
else
    log_warn "Nginx не найден. Убедитесь, что статические файлы из dist/ доступны через веб-сервер"
fi

log_info "✅ Деплой завершен успешно!"
log_info ""
log_info "Проверьте:"
log_info "  - Frontend собран в папке dist/"
log_info "  - Backend сервер запущен на порту 3001"
log_info "  - Nginx настроен для обслуживания статики из dist/"
log_info ""
log_info "Для проверки статуса backend:"
if command -v pm2 &> /dev/null; then
    log_info "  pm2 status"
else
    log_info "  ps aux | grep 'node.*server.js'"
fi

