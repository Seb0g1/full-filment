// Обработчик offline состояния

export function initOfflineHandler() {
  // Проверяем статус при загрузке
  if (!navigator.onLine) {
    // Если нет интернета и мы не на странице offline, перенаправляем
    if (window.location.pathname !== '/offline') {
      window.location.href = '/offline'
    }
  }

  // Слушаем события online/offline
  window.addEventListener('online', () => {
    // Если мы на странице offline и интернет восстановлен, возвращаемся назад
    if (window.location.pathname === '/offline') {
      const previousPath = sessionStorage.getItem('previousPath') || '/'
      window.location.href = previousPath
    }
  })

  window.addEventListener('offline', () => {
    // Сохраняем текущий путь перед переходом на offline страницу
    if (window.location.pathname !== '/offline') {
      sessionStorage.setItem('previousPath', window.location.pathname)
      window.location.href = '/offline'
    }
  })
}

