<script setup lang="ts">
import UserCrud from './components/Home.vue'
</script>

<template>
  <div>
    <a >
      <img src="./assets/aws.jpg" class="logo" alt="My Profile" />
    </a>
  </div>
  <UserCrud />
</template>

<style scoped>
.logo {
  height: 13em;
  width: 13em;
  padding: 1.5em;
  border-radius: 50%;
  object-fit: cover;
  will-change: filter, transform;
  transition: all 300ms ease-in-out;
  animation: pulse 2s infinite;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
  transform: scale(5.0);
  transition: transform 0.3s ease-in-out;
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% { transform: translateY(0) rotate(0deg); }
  40% { transform: translateY(-10px) rotate(180deg); }
  60% { transform: translateY(-5px) rotate(270deg); }
}
</style>
    