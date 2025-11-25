# Скрипт для правильной инициализации Git в директории проекта

$ErrorActionPreference = "Stop"

# Получаем текущую директорию скрипта
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "📁 Рабочая директория: $scriptDir" -ForegroundColor Cyan

# Удаляем старый .git если есть в этой директории
if (Test-Path ".git") {
    Write-Host "🗑️  Удаляем старый .git из директории проекта..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force .git
}

# Удаляем .git из домашней директории если он там есть
$homeGit = Join-Path $env:USERPROFILE ".git"
if (Test-Path $homeGit) {
    Write-Host "🗑️  Удаляем .git из домашней директории..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $homeGit -ErrorAction SilentlyContinue
}

# Инициализация git
Write-Host "📦 Инициализация Git..." -ForegroundColor Cyan
git init
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Ошибка при инициализации Git!" -ForegroundColor Red
    exit 1
}

# Переименование ветки
git branch -M main

# Настройка git config (если не настроено)
$userEmail = git config user.email
$userName = git config user.name

if (-not $userEmail) {
    Write-Host "⚠️  Email не настроен. Используем дефолтный..." -ForegroundColor Yellow
    git config user.email "seb0g1@users.noreply.github.com"
}

if (-not $userName) {
    Write-Host "⚠️  Имя не настроено. Используем дефолтное..." -ForegroundColor Yellow
    git config user.name "Seb0g1"
}

# Добавление remote
Write-Host "🔗 Настройка удаленного репозитория..." -ForegroundColor Cyan
git remote remove origin -ErrorAction SilentlyContinue
git remote add origin https://github.com/Seb0g1/full-filment.git

# Добавление файлов проекта
Write-Host "📝 Добавление файлов проекта..." -ForegroundColor Cyan
git add .

# Проверка статуса
$status = git status --short
if ($status) {
    Write-Host "✅ Файлы добавлены для коммита" -ForegroundColor Green
    
    # Создание коммита
    Write-Host "💾 Создание коммита..." -ForegroundColor Cyan
    git commit -m "first commit"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Git репозиторий успешно инициализирован!" -ForegroundColor Green
        Write-Host ""
        Write-Host "📤 Для загрузки на GitHub выполните:" -ForegroundColor Cyan
        Write-Host "   git push -u origin main" -ForegroundColor White
        Write-Host ""
        Write-Host "⚠️  Убедитесь, что репозиторий создан на GitHub: https://github.com/Seb0g1/full-filment" -ForegroundColor Yellow
    } else {
        Write-Host "❌ Ошибка при создании коммита!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "⚠️  Нет файлов для коммита (возможно, все уже закоммичены)" -ForegroundColor Yellow
}

