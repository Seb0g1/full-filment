<template>
  <footer class="footer">
    <div class="container">
      <div class="footer-content">
        <div class="footer-section">
          <div class="footer-logo">
            <img src="/logo.svg" alt="Sakoo Фулфилмент" class="footer-logo-img" />
            <div class="footer-logo-text">
              <span class="logo-text">Sakoo</span>
              <span class="logo-badge">Фулфилмент</span>
            </div>
          </div>
          <p class="footer-description">
            Профессиональный фулфилмент для маркетплейсов в Москве. 
            Быстрая доставка от 24 часов. От 25 руб/заказ.
          </p>
        </div>
        <div class="footer-section">
          <h3>Навигация</h3>
          <ul class="footer-links">
            <li><a href="#services">Услуги</a></li>
            <li><a href="#tariffs">Тарифы</a></li>
            <li><a href="#calculator">Расчет</a></li>
            <li><a href="#contacts">Контакты</a></li>
            <li><a href="#faq">FAQ</a></li>
          </ul>
        </div>
        <div class="footer-section">
          <h3>Контакты</h3>
          <ul class="footer-links">
            <li><a href="tel:+79002797068">+7 (900) 279-70-68</a></li>
            <li>МКАД 33 км, 6, Москва, 117405</li>
            <li>С 9:00 до 22:00</li>
          </ul>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&copy; 2025 Sakoo Фулфилмент. Все права защищены.</p>
        <a href="#" class="footer-link">Политика конфиденциальности</a>
      </div>
    </div>
  </footer>
</template>

<script setup>
// Компонент футера
</script>

<style scoped>
.footer {
  background: var(--dark-light);
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 3rem 0 1.5rem;
  margin-top: 4rem;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 3rem;
  margin-bottom: 2rem;
}

.footer-logo {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1rem;
}

.footer-logo-img {
  height: 40px;
  width: auto;
  display: block;
  flex-shrink: 0;
}

.footer-logo-text {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1.5rem;
  font-weight: 700;
}

.logo-text {
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.logo-badge {
  font-size: 0.75rem;
  padding: 0.25rem 0.75rem;
  background: var(--gradient-accent);
  border-radius: 20px;
  font-weight: 600;
}

.footer-description {
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
}

.footer-section h3 {
  font-size: 1.125rem;
  margin-bottom: 1rem;
  color: var(--white);
}

.footer-links {
  list-style: none;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.footer-links li {
  color: rgba(255, 255, 255, 0.7);
}

.footer-links a {
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  transition: color 0.3s ease;
}

.footer-links a:hover {
  color: var(--primary-light);
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 2rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  flex-wrap: wrap;
  gap: 1rem;
}

.footer-bottom p {
  color: rgba(255, 255, 255, 0.5);
  margin: 0;
}

.footer-link {
  color: rgba(255, 255, 255, 0.5);
  text-decoration: none;
  transition: color 0.3s ease;
  background: none;
  border: none;
  cursor: pointer;
  font-family: inherit;
  font-size: inherit;
  padding: 0;
}

.footer-link:hover {
  color: var(--primary-light);
}

.settings-link {
  opacity: 0.6;
  font-size: 0.875rem;
}

.settings-link:hover {
  opacity: 1;
}

@media (max-width: 768px) {
  .footer-content {
    grid-template-columns: 1fr;
    gap: 2rem;
  }

  .footer-logo-img {
    height: 32px;
  }

  .footer-logo-text {
    font-size: 1.25rem;
  }

  .footer-bottom {
    flex-direction: column;
    text-align: center;
  }
}
</style>
