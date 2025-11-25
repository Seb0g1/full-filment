# PowerShell скрипт для загрузки проекта на GitHub

Write-Host "🚀 Настройка Git и загрузка на GitHub..." -ForegroundColor Green

# Получаем путь к проекту из переменной окружения workspace
$projectPath = $PSScriptRoot
if (-not $projectPath) {
    $projectPath = Get-Location
}

Write-Host "📁 Директория проекта: $projectPath" -ForegroundColor Cyan

# Переходим в директорию проекта
Set-Location $projectPath

# Проверка наличия git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git не установлен! Установите Git: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

# Настройка git пользователя
Write-Host "👤 Настройка Git пользователя..." -ForegroundColor Cyan
git config user.email "seboggame@gmail.com"
git config user.name "Seb0g1"

# Проверяем, инициализирован ли git
if (-not (Test-Path ".git")) {
    Write-Host "📦 Инициализация Git..." -ForegroundColor Cyan
    git init
    git branch -M main
} else {
    Write-Host "✅ Git уже инициализирован" -ForegroundColor Green
}

# Добавление remote (удаляем старый если есть)
Write-Host "🔗 Настройка удаленного репозитория..." -ForegroundColor Cyan
git remote remove origin -ErrorAction SilentlyContinue

# Запрашиваем URL репозитория
$repoUrl = Read-Host "Введите URL репозитория GitHub (например: https://github.com/Seb0g1/full-filment.git) или нажмите Enter для использования https://github.com/Seb0g1/full-filment.git"
if ([string]::IsNullOrWhiteSpace($repoUrl)) {
    $repoUrl = "https://github.com/Seb0g1/full-filment.git"
}

git remote add origin $repoUrl
Write-Host "✅ Remote добавлен: $repoUrl" -ForegroundColor Green

# Очистка staging area от случайных файлов
Write-Host "🧹 Очистка staging area..." -ForegroundColor Cyan
git reset HEAD . 2>$null

# Добавление файлов проекта
Write-Host "📝 Добавление файлов проекта..." -ForegroundColor Cyan
# Используем git add с явными путями, чтобы избежать добавления файлов из родительской директории
git add .gitignore 2>$null
git add package.json 2>$null
git add package-lock.json 2>$null
Get-ChildItem -Path . -Include *.json,*.js,*.md,*.conf,*.sh,*.ps1,*.html -Recurse -File | ForEach-Object { git add $_.FullName -f 2>$null }
git add public/ 2>$null
git add src/ 2>$null
git add server/ 2>$null
git add index.html 2>$null
git add vite.config.js 2>$null
git add ecosystem.config.js 2>$null

# Проверка статуса
$status = git status --short
if ($status) {
    Write-Host "💾 Создание коммита..." -ForegroundColor Cyan
    git commit -m "Initial commit"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Коммит создан!" -ForegroundColor Green
        
        # Загрузка на GitHub
        Write-Host "📤 Загрузка на GitHub..." -ForegroundColor Cyan
        Write-Host "⚠️  Убедитесь, что репозиторий создан на GitHub!" -ForegroundColor Yellow
        Write-Host ""
        
        $push = Read-Host "Загрузить на GitHub? (y/n)"
        if ($push -eq "y" -or $push -eq "Y") {
            git push -u origin main
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Проект успешно загружен на GitHub!" -ForegroundColor Green
            } else {
                Write-Host "❌ Ошибка при загрузке. Проверьте:" -ForegroundColor Red
                Write-Host "   1. Репозиторий создан на GitHub" -ForegroundColor Yellow
                Write-Host "   2. У вас есть права на запись" -ForegroundColor Yellow
                Write-Host "   3. Используется правильный URL" -ForegroundColor Yellow
            }
        } else {
            Write-Host "📤 Для загрузки выполните: git push -u origin main" -ForegroundColor Cyan
        }
    } else {
        Write-Host "❌ Ошибка при создании коммита!" -ForegroundColor Red
    }
} else {
    Write-Host "ℹ️  Нет изменений для коммита" -ForegroundColor Yellow
    Write-Host "📤 Для загрузки выполните: git push -u origin main" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "✅ Готово!" -ForegroundColor Green

