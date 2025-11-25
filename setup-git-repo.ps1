# Скрипт для правильной настройки git репозитория в директории проекта

$ErrorActionPreference = "Stop"

Write-Host "🚀 Настройка Git репозитория для проекта..." -ForegroundColor Green

# Получаем путь к директории скрипта (директория проекта)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $scriptDir) {
    $scriptDir = Get-Location
}

Write-Host "📁 Директория проекта: $scriptDir" -ForegroundColor Cyan
Set-Location $scriptDir

# Проверяем, что это действительно директория проекта
if (-not (Test-Path "package.json")) {
    Write-Host "❌ Файл package.json не найден. Убедитесь, что скрипт запущен из директории проекта!" -ForegroundColor Red
    exit 1
}

# Проверка наличия git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git не установлен! Установите Git: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

# Проверяем, есть ли уже .git в директории проекта
$hasLocalGit = Test-Path ".git"
$parentGitRoot = $null
try {
    $parentGitRoot = git rev-parse --show-toplevel 2>$null
} catch {}

Write-Host ""
if ($hasLocalGit) {
    Write-Host "✅ Git репозиторий уже инициализирован в директории проекта" -ForegroundColor Green
} elseif ($parentGitRoot -and $parentGitRoot -ne $scriptDir) {
    Write-Host "⚠️  Обнаружен родительский git репозиторий в: $parentGitRoot" -ForegroundColor Yellow
    Write-Host "   Инициализируем новый репозиторий в директории проекта..." -ForegroundColor Cyan
}

# Инициализация git в директории проекта (если еще не инициализирован)
if (-not $hasLocalGit) {
    Write-Host "📦 Инициализация Git в директории проекта..." -ForegroundColor Cyan
    git init
    git branch -M main
}

# Настройка remote (удаляем старый если есть)
Write-Host "🔗 Настройка удаленного репозитория..." -ForegroundColor Cyan
git remote remove origin -ErrorAction SilentlyContinue
git remote add origin https://github.com/Seb0g1/full-filment.git
Write-Host "✅ Remote настроен: https://github.com/Seb0g1/full-filment.git" -ForegroundColor Green

# Добавление файлов проекта (только из текущей директории)
Write-Host "📝 Добавление файлов проекта..." -ForegroundColor Cyan

# Используем git add с явным указанием файлов проекта
git add .gitignore 2>$null
git add package.json 2>$null
git add package-lock.json 2>$null
git add "*.json" 2>$null
git add "*.js" 2>$null
git add "*.md" 2>$null
git add "*.conf" 2>$null
git add "*.sh" 2>$null
git add "*.ps1" 2>$null
git add index.html 2>$null
git add vite.config.js 2>$null

# Добавляем директории проекта
if (Test-Path "public") { git add public/ 2>$null }
if (Test-Path "src") { git add src/ 2>$null }
if (Test-Path "server") { git add server/ 2>$null }

# Проверяем статус
Write-Host ""
Write-Host "📊 Статус репозитория:" -ForegroundColor Cyan
git status --short | Select-Object -First 30

# Проверяем, есть ли изменения для коммита
$status = git status --porcelain
if ($status) {
    Write-Host ""
    Write-Host "💾 Создание коммита..." -ForegroundColor Cyan
    
    # Проверяем, есть ли уже коммиты
    $hasCommits = git log --oneline -1 2>$null
    $commitMsg = if ($hasCommits) { "Update project files" } else { "Initial commit" }
    
    git commit -m $commitMsg
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Коммит создан!" -ForegroundColor Green
    } else {
        Write-Host "❌ Ошибка при создании коммита" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host ""
    Write-Host "ℹ️  Нет изменений для коммита" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✅ Git репозиторий настроен!" -ForegroundColor Green
Write-Host ""
Write-Host "📤 Для отправки на GitHub выполните:" -ForegroundColor Cyan
Write-Host "   git push -u origin main" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Убедитесь, что:" -ForegroundColor Yellow
Write-Host "   1. Репозиторий создан на GitHub: https://github.com/Seb0g1/full-filment" -ForegroundColor Yellow
Write-Host "   2. У вас есть права на запись в репозиторий" -ForegroundColor Yellow
Write-Host "   3. Настроена аутентификация (Personal Access Token или SSH ключ)" -ForegroundColor Yellow

