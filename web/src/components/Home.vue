<script setup lang="ts">
import { ref, reactive } from 'vue'
import type { User } from '../types/User'

const users = ref<User[]>([])
const editingId = ref<number | null>(null)
const form = reactive({
  name: '',
  email: ''
})

let nextId = 1

const addUser = () => {
  if (!form.name || !form.email) return
  users.value.push({
    id: nextId++,
    name: form.name,
    email: form.email
  })
  resetForm()
}

const editUser = (user: User) => {
  editingId.value = user.id
  form.name = user.name
  form.email = user.email
}

const updateUser = () => {
  const user = users.value.find(u => u.id === editingId.value)
  if (user) {
    user.name = form.name
    user.email = form.email
  }
  resetForm()
}

const deleteUser = (id: number) => {
  users.value = users.value.filter(u => u.id !== id)
}

const resetForm = () => {
  form.name = ''
  form.email = ''
  editingId.value = null
}
</script>

<template>
  <div class="crud-container">
    <h2 class="welcome-text"> Welcome to AWS First Cloud Journey</h2>
    <div class="blog-links">
      <a href="https://hs-nguyen.hashnode.dev/" target="_blank">Visit my Hashnode Blog</a>
      <a href="https://www.linkedin.com/in/nguyen-huu-sang/" target="_blank">Linkedin Profile</a>
      <a href="https://cloudjourney.awsstudygroup.com/" target="_blank">AWS First Cloud Journey</a>
      <a href="https://www.facebook.com/groups/660548818043427" target="_blank">AWS Study Group VN</a>
    </div>
    <form @submit.prevent="editingId ? updateUser() : addUser()" class="form">
      <input v-model="form.name" placeholder="Name" required />
      <input v-model="form.email" type="email" placeholder="Email" required />
      <button type="submit">{{ editingId ? 'Update' : 'Add' }}</button>
      <button v-if="editingId" type="button" @click="resetForm()">Cancel</button>
    </form>

    <table v-if="users.length">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Email</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td>{{ user.id }}</td>
          <td>{{ user.name }}</td>
          <td>{{ user.email }}</td>
          <td>
            <button @click="editUser(user)">Edit</button>
            <button @click="deleteUser(user.id)">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
    
    <p v-else>No users found.</p>
  </div>
</template>

<style scoped>
.crud-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.blog-links {
  display: flex;
  gap: 15px;
  margin: 15px 0;
  justify-content: center;
}

.blog-links a {
  padding: 8px 16px;
  background: #007bff;
  color: rgb(255, 255, 255);
  text-decoration: none;
  border-radius: 4px;
  transition: background 0.3s;
}

.blog-links a:hover {
  background: #0a4687;
}

.form {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  justify-content: center;
}

.form input {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.form button {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.form button[type="submit"] {
  background: #007bff;
  color: white;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

th {
  background: #f5f5f5;
}

button {
  padding: 4px 8px;
  margin: 0 2px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:first-child {
  background: #28a745;
  color: white;
}

button:last-child {
  background: #dc3545;
  color: white;
}

.welcome-text {
  background: linear-gradient(45deg, #ff6b35, #f7931e, #ffd23f, #06ffa5, #4ecdc4, #45b7d1, #96ceb4, #feca57);
  background-size: 50% 50%;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: gradientShift 3s ease-in-out infinite, bounce 3s ease-in-out infinite;
  text-align: center;
  font-size: 2.5em;
  font-weight: bold;
}

@keyframes gradientShift {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

@media (max-width: 768px) {
  .crud-container {
    padding: 10px;
  }

  .welcome-text {
    font-size: 1.8em;
  }

  .blog-links {
    flex-direction: column;
    gap: 10px;
  }

  .form {
    flex-direction: column;
    gap: 10px;
  }

  .form input {
    width: 100%;
    box-sizing: border-box;
  }

  table {
    font-size: 14px;
  }

  th, td {
    padding: 8px 4px;
  }

  button {
    padding: 6px 8px;
    font-size: 12px;
  }
}
</style>