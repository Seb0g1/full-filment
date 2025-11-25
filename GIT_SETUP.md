# Инструкция по настройке Git и загрузке на GitHub

## Важно!

Git был инициализирован в неправильной директории. Нужно инициализировать его в директории проекта.

## Шаги для Windows

1. **Откройте PowerShell или Git Bash в директории проекта:**
   ```
   cd "C:\Users\Хуйню придумал\Downloads\FulFilment (1)"
   ```

2. **Удалите старый git репозиторий (если он был создан в неправильном месте):**
   ```powershell
   Remove-Item -Recurse -Force .git -ErrorAction SilentlyContinue
   ```

3. **Инициализируйте git в правильной директории:**
   ```powershell
   git init
   git branch -M main
   ```

4. **Настройте git (если еще не настроено):**
   ```powershell
   git config user.email "your-email@example.com"
   git config user.name "Your Name"
   ```

5. **Добавьте удаленный репозиторий:**
   ```powershell
   git remote add origin https://github.com/Seb0g1/full-filment.git
   ```

6. **Добавьте файлы:**
   ```powershell
   git add .
   ```

7. **Создайте первый коммит:**
   ```powershell
   git commit -m "first commit"
   ```

8. **Загрузите на GitHub:**
   ```powershell
   git push -u origin main
   ```

## Альтернативный способ (через скрипт)

Запустите `git-init.ps1` в PowerShell:

```powershell
.\git-init.ps1
```

## После загрузки на GitHub

На сервере выполните:

```bash
git clone https://github.com/Seb0g1/full-filment.git
cd full-filment
./setup.sh
```

