<script setup>
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap'

import { ref, computed, onMounted } from 'vue'
import { createClient } from '@supabase/supabase-js'

const users = ref([])
const searchQuery = ref('')
const ageFilter = ref(0)

let supabase = null

const supabaseUrl = import.meta.env.VITE_URL
const supabaseKey = import.meta.env.VITE_API_KEY

supabase = createClient(supabaseUrl, supabaseKey)

const filteredUsers = computed(() => {
  return users.value.filter((user) => {
    const matchesSearchQuery = user.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchesAgeFilter = user.age >= ageFilter.value
    return matchesSearchQuery && matchesAgeFilter
  })
})

onMounted(() => {
  fetchUsers()
})

async function fetchUsers() {
  try {
    const { data, error } = await supabase.from('users').select('*')
    if (error) throw error
    users.value = data
  } catch (error) {
    console.error('Error fetching users:', error.message)
  }
}
</script>

<template>
  <div class="container px-4 py-5" id="icon-grid">
    <h2 class="pb-2 border-bottom">Users</h2>

    <div class="mb-4">
      <input
        v-model="searchQuery"
        type="text"
        class="form-control"
        placeholder="Search for a user by name"
      />
    </div>

    <div class="mb-4">
      <label for="ageFilter" class="form-label">Age Filter: {{ ageFilter }}+</label>
      <input
        v-model="ageFilter"
        type="range"
        class="form-range"
        min="0"
        max="100"
        step="1"
        id="ageFilter"
      />
    </div>

    <div
      v-if="filteredUsers.length"
      class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4 py-5"
    >
      <div v-for="user in filteredUsers" :key="user.id" class="col d-flex align-items-start">
        <img
          src="@/assets/images/user.png"
          alt=""
          class="bi text-body-secondary flex-shrink-0 me-3"
          style="height: 2em; width: 2em"
        />
        <div>
          <h3 class="fw-bold mb-0 fs-4 text-body-emphasis">{{ user.name }}</h3>
          <p>{{ user.age }} years old.</p>
        </div>
      </div>
    </div>

    <div v-else-if="filteredUsers.length === 0 && users.length > 0" class="text-center py-5">
      <p>No users found matching your search or filter criteria.</p>
    </div>

    <div v-else class="d-flex justify-content-center align-items-center vh-50">
      <button class="btn btn-secondary" type="button" disabled>
        <span class="spinner-border spinner-border-lg" role="status" aria-hidden="true"></span>
      </button>
    </div>
  </div>
</template>
