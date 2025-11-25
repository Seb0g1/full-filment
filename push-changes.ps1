# Скрипт для отправки изменений на GitHub
# Использование: .\push-changes.ps1

$ErrorActionPreference = "Stop"

Write-Host "🚀 Отправка изменений на GitHub..." -ForegroundColor Green

# Получаем директорию скрипта
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "📁 Рабочая директория: $scriptDir" -ForegroundColor Cyan

# Проверка наличия git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git не установлен!" -ForegroundColor Red
    exit 1
}

# Проверка, что мы в правильной директории
if (-not (Test-Path "package.json")) {
    Write-Host "❌ Файл package.json не найден. Убедитесь, что вы в директории проекта!" -ForegroundColor Red
    exit 1
}

# Проверка наличия .git
if (-not (Test-Path ".git")) {
    Write-Host "📦 Инициализация Git репозитория..." -ForegroundColor Cyan
    git init
    git branch -M main
    
    # Настройка remote
    git remote remove origin -ErrorAction SilentlyContinue
    git remote add origin https://github.com/Seb0g1/full-filment.git
    Write-Host "✅ Git репозиторий инициализирован" -ForegroundColor Green
}

# Проверка статуса
Write-Host "`n📊 Проверка изменений..." -ForegroundColor Cyan
$status = git status --porcelain

if (-not $status) {
    Write-Host "ℹ️  Нет изменений для коммита" -ForegroundColor Yellow
    
    # Проверяем, есть ли коммиты для отправки
    $localCommits = git log origin/main..HEAD --oneline 2>$null
    if ($localCommits) {
        Write-Host "📤 Отправка существующих коммитов..." -ForegroundColor Cyan
        git push origin main
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Коммиты успешно отправлены!" -ForegroundColor Green
        }
    } else {
        Write-Host "✅ Всё синхронизировано с GitHub" -ForegroundColor Green
    }
    exit 0
}

# Показываем изменения
Write-Host "`n📝 Найденные изменения:" -ForegroundColor Cyan
git status --short

# Добавляем измененные файлы
Write-Host "`n➕ Добавление изменений..." -ForegroundColor Cyan
git add src/utils/chatService.js
git add src/utils/telegram.js
git add server/server.js
git add DEPLOY.md
git add ecosystem.config.js
git add FIX_ENV_ISSUE.md
git add SERVER_TELEGRAM_SETUP.md
git add DEPLOY_WORKFLOW.md
git add PUSH_CHANGES.md
git add push-changes.ps1

# Проверяем, что файлы добавлены
$staged = git diff --cached --name-only
if ($staged) {
    Write-Host "✅ Добавлены файлы:" -ForegroundColor Green
    $staged | ForEach-Object { Write-Host "   - $_" -ForegroundColor Gray }
} else {
    Write-Host "⚠️  Нет файлов для добавления" -ForegroundColor Yellow
}

# Создаем коммит
Write-Host "`n💾 Создание коммита..." -ForegroundColor Cyan
$commitMsg = "Fix: Исправлена ошибка ERR_CONNECTION_REFUSED и добавлена отладка для .env файла"
git commit -m $commitMsg

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Коммит создан!" -ForegroundColor Green
    
    # Отправка на GitHub
    Write-Host "`n📤 Отправка на GitHub..." -ForegroundColor Cyan
    git push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ Изменения успешно отправлены на GitHub!" -ForegroundColor Green
        Write-Host "🔗 Репозиторий: https://github.com/Seb0g1/full-filment" -ForegroundColor Cyan
    } else {
        Write-Host "`n❌ Ошибка при отправке на GitHub" -ForegroundColor Red
        Write-Host "   Возможные причины:" -ForegroundColor Yellow
        Write-Host "   1. Не настроена аутентификация (Personal Access Token или SSH)" -ForegroundColor Yellow
        Write-Host "   2. Нет прав на запись в репозиторий" -ForegroundColor Yellow
        Write-Host "   3. Нужно сначала выполнить: git pull origin main" -ForegroundColor Yellow
        Write-Host "`n   Попробуйте выполнить вручную: git push origin main" -ForegroundColor Cyan
    }
} else {
    Write-Host "❌ Ошибка при создании коммита" -ForegroundColor Red
    Write-Host "   Возможно, нет изменений для коммита" -ForegroundColor Yellow
}

Write-Host ""

