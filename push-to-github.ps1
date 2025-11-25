# PowerShell скрипт для загрузки проекта на GitHub
# Работает из директории проекта

$ErrorActionPreference = "Stop"

# Получаем путь к скрипту (директория проекта)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "📁 Рабочая директория: $scriptPath" -ForegroundColor Cyan

# Удаляем .git из домашней директории если он там есть
$homeGit = Join-Path $env:USERPROFILE ".git"
if (Test-Path $homeGit) {
    Write-Host "🗑️  Удаление .git из домашней директории..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $homeGit -ErrorAction SilentlyContinue
}

# Удаляем старый .git в проекте если есть
if (Test-Path ".git") {
    Write-Host "🗑️  Удаление старого .git..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force .git
}

# Инициализация git
Write-Host "📦 Инициализация Git..." -ForegroundColor Cyan
git init
git branch -M main

# Настройка Git пользователя (если не настроено)
Write-Host "👤 Проверка настроек Git пользователя..." -ForegroundColor Cyan
$gitUser = git config user.name
$gitEmail = git config user.email

if (-not $gitUser -or -not $gitEmail) {
    Write-Host "⚠️  Git пользователь не настроен. Настройка для этого репозитория..." -ForegroundColor Yellow
    
    # Пытаемся использовать переменные окружения или системную информацию
    if (-not $gitUser) {
        $gitUser = $env:GIT_USER_NAME
        if (-not $gitUser) {
            $gitUser = $env:USERNAME
            if (-not $gitUser) {
                $gitUser = "Git User"
            }
        }
        git config user.name $gitUser
        Write-Host "   Установлено имя: $gitUser" -ForegroundColor Gray
    }
    
    if (-not $gitEmail) {
        $gitEmail = $env:GIT_USER_EMAIL
        if (-not $gitEmail) {
            # Пытаемся создать email на основе имени пользователя
            $username = $env:USERNAME
            if ($username) {
                $gitEmail = "$username@users.noreply.github.com"
            } else {
                $gitEmail = "git@example.com"
            }
        }
        git config user.email $gitEmail
        Write-Host "   Установлен email: $gitEmail" -ForegroundColor Gray
    }
    
    Write-Host "✅ Git пользователь настроен: $gitUser ($gitEmail)" -ForegroundColor Green
    Write-Host "💡 Для изменения используйте: git config user.name 'Ваше Имя' и git config user.email 'your@email.com'" -ForegroundColor Cyan
} else {
    Write-Host "✅ Git пользователь уже настроен: $gitUser ($gitEmail)" -ForegroundColor Green
}

# Настройка remote
Write-Host "🔗 Настройка удаленного репозитория..." -ForegroundColor Cyan
$remoteExists = git remote get-url origin -ErrorAction SilentlyContinue
if ($remoteExists) {
    Write-Host "🔄 Обновление существующего remote origin..." -ForegroundColor Yellow
    git remote set-url origin https://github.com/Seb0g1/full-filment.git
} else {
    git remote add origin https://github.com/Seb0g1/full-filment.git
}

# Добавление файлов проекта
Write-Host "📝 Добавление файлов..." -ForegroundColor Cyan
git add .

# Создание коммита
Write-Host "💾 Создание коммита..." -ForegroundColor Cyan
$commitResult = git commit -m "first commit" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Ошибка при создании коммита:" -ForegroundColor Red
    Write-Host $commitResult -ForegroundColor Red
    exit 1
}

# Загрузка на GitHub
Write-Host "📤 Загрузка на GitHub..." -ForegroundColor Cyan
$pushResult = git push -u origin main 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Ошибка при загрузке на GitHub:" -ForegroundColor Red
    Write-Host $pushResult -ForegroundColor Red
    Write-Host "`n💡 Возможные решения:" -ForegroundColor Yellow
    Write-Host "   1. Проверьте, что репозиторий существует на GitHub" -ForegroundColor Yellow
    Write-Host "   2. Убедитесь, что у вас есть права на запись в репозиторий" -ForegroundColor Yellow
    Write-Host "   3. Проверьте подключение к интернету" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Готово! Проект успешно загружен на GitHub." -ForegroundColor Green

