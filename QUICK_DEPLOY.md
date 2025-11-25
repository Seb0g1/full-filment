# 🚀 Быстрый деплой: GitHub → Сервер

## 📤 Шаг 1: Загрузить на GitHub (локально)

### Способ 1: Автоматический скрипт
```powershell
.\push-changes.ps1
```

### Способ 2: Вручную
```powershell
git add .
git commit -m "Fix: Исправления и обновления"
git push origin main
```

## 📥 Шаг 2: Обновить на сервере

### Подключитесь к серверу по SSH:
```bash
ssh user@your-server.com
```

### Выполните одну команду:
```bash
cd /path/to/full-filment && ./deploy.sh
```

Или вручную:
```bash
cd /path/to/full-filment
git pull origin main
npm install
cd server && npm install && cd ..
npm run build
pm2 restart fulfillment-bot --update-env
```

## ✅ Проверка

```bash
pm2 logs fulfillment-bot --lines 30
```

---

**Подробная инструкция:** см. `DEPLOY_WORKFLOW.md`

