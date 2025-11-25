import { createApp } from 'vue'
import App from './App.vue'
import './style.css'
import router from './router'
import { initOfflineHandler } from './utils/offlineHandler'

const app = createApp(App)
app.use(router)

// Инициализация обработчика offline
initOfflineHandler()

app.mount('#app')
