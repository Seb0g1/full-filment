# Инструкция по отправке проекта на GitHub

## ⚠️ Важно!

Git репозиторий был инициализирован в неправильной директории (в домашней папке пользователя). Нужно инициализировать его заново в директории проекта.

## Быстрый способ (рекомендуется)

### Вариант 1: Через PowerShell скрипт

1. Откройте PowerShell **в директории проекта** (`C:\Users\Хуйню придумал\Downloads\fullMilment`)
2. Выполните:
   ```powershell
   .\github-push.ps1
   ```

### Вариант 2: Вручную через команды

1. Откройте PowerShell или Git Bash **в директории проекта**
2. Выполните следующие команды:

```powershell
# Перейти в директорию проекта
cd "C:\Users\Хуйню придумал\Downloads\fullMilment"

# Удалить старый репозиторий из родительской директории (если он там есть)
# ВНИМАНИЕ: Это удалит репозиторий из C:\Users\Хуйню придумал\.git
# Если вы не хотите удалять его, просто инициализируйте новый в директории проекта

# Инициализировать git в директории проекта
git init
git branch -M main

# Настроить удаленный репозиторий
git remote remove origin
git remote add origin https://github.com/Seb0g1/full-filment.git

# Добавить файлы проекта
git add .

# Проверить, что добавились только файлы проекта (не файлы из AppData и т.д.)
git status

# Если всё правильно, создать коммит
git commit -m "Initial commit"

# Отправить на GitHub
git push -u origin main
```

## Проверка перед отправкой

Убедитесь, что:

1. ✅ Репозиторий создан на GitHub: https://github.com/Seb0g1/full-filment
2. ✅ У вас есть права на запись в репозиторий
3. ✅ Настроена аутентификация:
   - Либо используйте Personal Access Token (GitHub → Settings → Developer settings → Personal access tokens)
   - Либо настройте SSH ключ

## Настройка аутентификации

### Personal Access Token (рекомендуется для HTTPS)

1. Создайте токен: https://github.com/settings/tokens
2. При `git push` введите ваш GitHub username и используйте токен как пароль

### Или настройте SSH

```powershell
# Генерация SSH ключа (если ещё нет)
ssh-keygen -t ed25519 -C "seboggame@gmail.com"

# Скопировать публичный ключ
cat ~/.ssh/id_ed25519.pub

# Добавить ключ в GitHub: Settings → SSH and GPG keys → New SSH key
```

## Если возникли проблемы

1. Убедитесь, что вы находитесь в правильной директории проекта
2. Проверьте `.gitignore` - он должен исключать `node_modules`, `dist`, `AppData` и другие ненужные файлы
3. Проверьте статус: `git status`

## После успешной отправки

Проект будет доступен по адресу:
https://github.com/Seb0g1/full-filment

