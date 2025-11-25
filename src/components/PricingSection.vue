<template>
  <section id="tariffs" class="pricing section fade-in-section">
    <div class="container">
      <h2 class="text-center mb-4">Тарифы на складские услуги</h2>
      <div class="pricing-grid">
        <div class="pricing-card glass card-hover">
          <div class="pricing-header">
            <h3>Приемка, хранение, комплектация</h3>
          </div>
          <div class="pricing-items">
            <div class="pricing-item">
              <span class="item-label">Приемка поступивших товаров</span>
              <span class="item-price">от 5 руб/шт</span>
            </div>
            <div class="pricing-item">
              <span class="item-label">Хранение товаров на своем складе</span>
              <span class="item-price">от 10 руб/сут</span>
            </div>
            <div class="pricing-item">
              <span class="item-label">Комплектация за каждую единицу товара в заказе</span>
              <span class="item-price">15 руб/шт</span>
            </div>
          </div>
        </div>
        <div class="pricing-card glass featured">
          <div class="pricing-badge">Популярно</div>
          <div class="pricing-header">
            <h3>Отгрузка и доставка</h3>
          </div>
          <div class="pricing-items">
            <div class="pricing-item">
              <span class="item-label">Подготовка товара</span>
              <span class="item-price">от 7 руб/ед</span>
            </div>
            <div class="pricing-item">
              <span class="item-label">Упаковка, отгрузка и доставка оптового заказа</span>
              <span class="item-price">от 100 руб/заказ</span>
            </div>
            <div class="pricing-item">
              <span class="item-label">Доставка заказа до маркетплейса (FBO)</span>
              <span class="item-price">от 990 руб/заказ</span>
            </div>
          </div>
        </div>
      </div>
      <div class="pricing-cta text-center mt-4">
        <a href="#calculator" class="btn btn-large">Посмотреть весь прайс</a>
      </div>
    </div>
  </section>
</template>

<style scoped>
.pricing {
  background: var(--dark-light);
}

.pricing-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 2rem;
  margin-top: 3rem;
}

.pricing-card {
  padding: 2.5rem;
  position: relative;
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  border: 2px solid transparent;
  background: rgba(255, 255, 255, 0.02);
}

.pricing-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
  border-color: rgba(113, 59, 219, 0.3);
  background: rgba(255, 255, 255, 0.03);
}

.pricing-card.featured {
  border-color: rgba(113, 59, 219, 0.3);
  background: rgba(113, 59, 219, 0.05);
}

.pricing-badge {
  position: absolute;
  top: -12px;
  right: 2rem;
  padding: 0.5rem 1.25rem;
  background: var(--gradient-primary);
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--white);
  box-shadow: 0 4px 12px rgba(113, 59, 219, 0.3);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.pricing-header {
  margin-bottom: 2rem;
}

.pricing-header h3 {
  font-size: 1.75rem;
  color: var(--white);
}

.pricing-items {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.pricing-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 10px;
  transition: all 0.3s ease;
}

.pricing-item:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: translateX(5px);
}

.item-label {
  color: rgba(255, 255, 255, 0.8);
  flex: 1;
  margin-right: 1rem;
}

.item-price {
  font-size: 1.25rem;
  font-weight: 700;
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  white-space: nowrap;
  transition: all 0.2s ease;
}

.pricing-item:hover .item-price {
  transform: scale(1.05);
}

.pricing-cta {
  margin-top: 3rem;
}

@media (max-width: 768px) {
  .pricing-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }

  .pricing-card {
    padding: 2rem;
  }

  .pricing-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }

  .item-price {
    font-size: 1.125rem;
  }
}
</style>
