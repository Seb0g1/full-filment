# PowerShell скрипт для инициализации Git репозитория

Write-Host "🚀 Инициализация Git репозитория..." -ForegroundColor Green

# Проверка наличия git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git не установлен! Установите Git: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

# Получаем текущую директорию
$projectDir = Get-Location

Write-Host "📁 Текущая директория: $projectDir" -ForegroundColor Cyan

# Удаляем старый .git если есть
if (Test-Path ".git") {
    Write-Host "🗑️  Удаляем старый .git..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force .git
}

# Инициализация git
Write-Host "📦 Инициализация Git..." -ForegroundColor Cyan
git init
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Ошибка при инициализации Git!" -ForegroundColor Red
    exit 1
}

# Переименование ветки в main
Write-Host "🌿 Создание ветки main..." -ForegroundColor Cyan
git branch -M main

# Проверка конфигурации git
$userEmail = git config user.email
$userName = git config user.name

if (-not $userEmail -or -not $userName) {
    Write-Host "⚠️  Git не настроен. Настройте пользователя:" -ForegroundColor Yellow
    $email = Read-Host "Введите email"
    $name = Read-Host "Введите имя"
    git config user.email $email
    git config user.name $name
}

# Добавление remote
Write-Host "🔗 Добавление удаленного репозитория..." -ForegroundColor Cyan
git remote remove origin -ErrorAction SilentlyContinue
git remote add origin https://github.com/Seb0g1/full-filment.git

# Добавление файлов
Write-Host "📝 Добавление файлов..." -ForegroundColor Cyan
git add .

# Создание коммита
Write-Host "💾 Создание первого коммита..." -ForegroundColor Cyan
git commit -m "first commit"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Ошибка при создании коммита!" -ForegroundColor Red
    Write-Host "Возможно, нет файлов для коммита или они уже закоммичены." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "✅ Git репозиторий инициализирован!" -ForegroundColor Green
Write-Host ""
Write-Host "📤 Для загрузки на GitHub выполните:" -ForegroundColor Cyan
Write-Host "   git push -u origin main" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Если репозиторий на GitHub еще не создан, создайте его сначала на https://github.com/new" -ForegroundColor Yellow

