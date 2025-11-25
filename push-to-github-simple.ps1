# Простой скрипт для отправки проекта на GitHub
# Работает из текущей директории проекта

$ErrorActionPreference = "Stop"

Write-Host "🚀 Подготовка проекта для GitHub..." -ForegroundColor Green

# Получаем текущую директорию проекта
$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $projectDir) {
    $projectDir = Get-Location
}

Write-Host "📁 Рабочая директория: $projectDir" -ForegroundColor Cyan
Set-Location $projectDir

# Проверка наличия git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git не установлен!" -ForegroundColor Red
    exit 1
}

# Проверяем, что мы в правильной директории (есть package.json)
if (-not (Test-Path "package.json")) {
    Write-Host "❌ Файл package.json не найден. Убедитесь, что вы в директории проекта!" -ForegroundColor Red
    exit 1
}

# Очищаем staging area от случайных файлов
Write-Host "🧹 Очистка staging area..." -ForegroundColor Cyan
git reset HEAD . 2>$null

# Удаляем из индекса все файлы вне проекта (если они были добавлены)
Write-Host "📝 Добавление только файлов проекта..." -ForegroundColor Cyan
git add .gitignore
git add package.json
git add package-lock.json
git add *.json
git add *.js
git add *.md
git add *.conf
git add *.sh
git add index.html
git add vite.config.js
git add public/
git add src/
git add server/

# Проверяем статус
$status = git status --porcelain
if ($status) {
    Write-Host "📦 Найдены изменения для коммита" -ForegroundColor Green
    
    # Создаем коммит
    Write-Host "💾 Создание коммита..." -ForegroundColor Cyan
    $commitMsg = "Initial project setup"
    if (git log --oneline -1 2>$null) {
        $commitMsg = "Update project files"
    }
    
    git commit -m $commitMsg
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Коммит создан!" -ForegroundColor Green
        
        # Отправка на GitHub
        Write-Host "📤 Отправка на GitHub..." -ForegroundColor Cyan
        git push -u origin main
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Проект успешно отправлен на GitHub!" -ForegroundColor Green
        } else {
            Write-Host "❌ Ошибка при отправке. Возможно нужно настроить аутентификацию." -ForegroundColor Red
            Write-Host "   Попробуйте: git push -u origin main" -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ Ошибка при создании коммита" -ForegroundColor Red
    }
} else {
    Write-Host "ℹ️  Нет изменений для коммита" -ForegroundColor Yellow
    Write-Host "📤 Отправка существующего коммита на GitHub..." -ForegroundColor Cyan
    git push -u origin main
}

Write-Host ""
Write-Host "✅ Готово!" -ForegroundColor Green

