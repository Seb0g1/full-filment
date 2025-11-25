# Как загрузить обновления на GitHub

## Быстрый способ

### Вариант 1: Использовать готовый скрипт

Откройте PowerShell в директории проекта и выполните:

```powershell
.\push-to-github-simple.ps1
```

### Вариант 2: Вручную (рекомендуется)

1. Откройте PowerShell или Git Bash **в директории проекта**:
   ```
   C:\Users\Хуйню придумал\Downloads\full-fillment\full-filment
   ```

2. Выполните следующие команды:

```powershell
# Проверить статус изменений
git status

# Добавить измененные файлы
git add src/utils/chatService.js
git add src/utils/telegram.js
git add DEPLOY.md

# Создать коммит с описанием изменений
git commit -m "Fix: Исправлена ошибка ERR_CONNECTION_REFUSED - использование относительных путей для API"

# Отправить на GitHub
git push origin main
```

## Если репозиторий не настроен

Если вы видите ошибку "fatal: not a git repository", выполните:

```powershell
# Инициализировать git (если еще не инициализирован)
git init
git branch -M main

# Настроить удаленный репозиторий
git remote add origin https://github.com/Seb0g1/full-filment.git

# Добавить все файлы проекта
git add .

# Создать первый коммит
git commit -m "Initial commit"

# Отправить на GitHub
git push -u origin main
```

## Настройка аутентификации

Если при `git push` запрашивается пароль:

1. **Используйте Personal Access Token:**
   - Создайте токен: https://github.com/settings/tokens
   - При запросе пароля введите токен (не ваш обычный пароль)

2. **Или настройте SSH:**
   ```powershell
   # Проверить существующие SSH ключи
   ls ~/.ssh
   
   # Если ключей нет, создать новый
   ssh-keygen -t ed25519 -C "seboggame@gmail.com"
   
   # Скопировать публичный ключ
   cat ~/.ssh/id_ed25519.pub
   
   # Добавить ключ в GitHub: Settings → SSH and GPG keys → New SSH key
   ```

## Что было изменено

- ✅ `src/utils/chatService.js` - теперь использует относительные пути вместо localhost:3001
- ✅ `src/utils/telegram.js` - теперь использует относительные пути вместо localhost:3001  
- ✅ `DEPLOY.md` - добавлена информация о решении проблемы ERR_CONNECTION_REFUSED

Эти изменения исправляют ошибку `ERR_CONNECTION_REFUSED` на продакшене, так как теперь frontend использует относительные пути, которые проксируются через Nginx.

