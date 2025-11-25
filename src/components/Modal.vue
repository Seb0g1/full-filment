<template>
  <Transition name="modal">
    <div v-if="modelValue" class="modal-overlay" @click.self="close">
      <div class="modal-content glass">
        <button class="modal-close" @click="close" aria-label="Закрыть">
          <X :size="24" />
        </button>
        <div class="modal-body">
          <div class="modal-icon" :class="type">
            <CheckCircle v-if="type === 'success'" :size="64" />
            <AlertCircle v-if="type === 'error'" :size="64" />
            <Loader2 v-if="type === 'loading'" :size="64" class="spinner" />
          </div>
          <h2 class="modal-title">{{ title }}</h2>
          <p class="modal-message" v-html="message"></p>
          <button v-if="type !== 'loading'" @click="close" class="btn btn-large" style="margin-top: 1.5rem;">
            Закрыть
          </button>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script setup>
import { X, CheckCircle, AlertCircle, Loader2 } from 'lucide-vue-next'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  type: {
    type: String,
    default: 'success',
    validator: (value) => ['success', 'error', 'loading'].includes(value)
  },
  title: {
    type: String,
    default: 'Успешно'
  },
  message: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update:modelValue'])

const close = () => {
  emit('update:modelValue', false)
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.75);
  backdrop-filter: blur(8px);
  z-index: 10000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  animation: fadeIn 0.2s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.modal-content {
  width: 100%;
  max-width: 500px;
  position: relative;
  animation: slideUp 0.3s ease;
  padding: 2.5rem;
}

@keyframes slideUp {
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.modal-close {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  padding: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 6px;
  transition: all 0.2s ease;
  z-index: 1;
}

.modal-close:hover {
  background: rgba(255, 255, 255, 0.1);
  color: var(--white);
}

.modal-body {
  text-align: center;
}

.modal-icon {
  margin: 0 auto 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100px;
  height: 100px;
  border-radius: 50%;
}

.modal-icon.success {
  color: #4ade80;
  background: rgba(34, 197, 94, 0.1);
}

.modal-icon.error {
  color: #f87171;
  background: rgba(239, 68, 68, 0.1);
}

.modal-icon.loading {
  color: var(--primary);
  background: rgba(99, 102, 241, 0.1);
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.modal-title {
  font-size: 1.75rem;
  font-weight: 700;
  margin-bottom: 1rem;
  color: var(--white);
}

.modal-message {
  font-size: 1.125rem;
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.6;
  margin-bottom: 1rem;
}

.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.2s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-active .modal-content,
.modal-leave-active .modal-content {
  transition: transform 0.3s ease, opacity 0.3s ease;
}

.modal-enter-from .modal-content,
.modal-leave-to .modal-content {
  transform: translateY(20px);
  opacity: 0;
}

@media (max-width: 768px) {
  .modal-content {
    padding: 2rem 1.5rem;
  }

  .modal-icon {
    width: 80px;
    height: 80px;
    margin-bottom: 1rem;
  }

  .modal-icon svg {
    width: 48px;
    height: 48px;
  }

  .modal-title {
    font-size: 1.5rem;
  }

  .modal-message {
    font-size: 1rem;
  }
}
</style>
