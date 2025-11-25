# Как запустить PowerShell скрипт push-to-github.ps1

## Способ 1: Через PowerShell (рекомендуется)

1. Откройте PowerShell (Win + X → Windows PowerShell или Terminal)
2. Перейдите в директорию проекта:
   ```powershell
   cd "C:\Users\Хуйню придумал\Downloads\fullMilment"
   ```
3. Запустите скрипт:
   ```powershell
   .\push-to-github.ps1
   ```

Если появится ошибка о политике выполнения, используйте:
```powershell
powershell -ExecutionPolicy Bypass -File .\push-to-github.ps1
```

## Способ 2: Через Проводник Windows

1. Откройте Проводник и перейдите в папку проекта
2. Правой кнопкой мыши на файл `push-to-github.ps1`
3. Выберите "Выполнить с PowerShell"

## Способ 3: Из командной строки (CMD)

```cmd
cd "C:\Users\Хуйню придумал\Downloads\fullMilment"
powershell -ExecutionPolicy Bypass -File push-to-github.ps1
```

## Способ 4: Изменение политики выполнения (для постоянного использования)

Если хотите разрешить выполнение скриптов навсегда, выполните в PowerShell от имени администратора:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

После этого можно запускать скрипты просто командой:
```powershell
.\push-to-github.ps1
```

## Примечания

- Скрипт автоматически настроит Git пользователя, если он не настроен
- Убедитесь, что у вас есть доступ к интернету
- Проверьте, что репозиторий `https://github.com/Seb0g1/full-filment.git` существует и у вас есть права на запись



