<script setup>
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap'
</script>
<template>
  <div v-if="users.length">
    <div class="container px-4 py-5" id="icon-grid">
      <h2 class="pb-2 border-bottom">Users</h2>

      <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4 py-5">
        <div v-for="user in users" :key="user.id" class="col d-flex align-items-start">
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
    </div>
  </div>
  <div v-else class="d-flex justify-content-center align-items-center vh-100">
    <button class="btn btn-secondary" type="button" disabled>
      <span class="spinner-border spinner-border-lg" role="status" aria-hidden="true"></span>
    </button>
  </div>
  <!-- <p>Loading</p> -->
</template>

<script>
import { createClient } from '@supabase/supabase-js'

export default {
  data() {
    return {
      users: [], // Holds the list of users
      supabase: null, // Supabase client
    }
  },
  async created() {
    // Supabase project details
    const supabaseUrl = 'SUPABASE_URL'
    const supabaseKey = 'SUPABASE_API_KEY'

    // Initialize Supabase client
    this.supabase = createClient(supabaseUrl, supabaseKey)

    // Fetch users from the 'users' table
    await this.fetchUsers()
  },
  methods: {
    async fetchUsers() {
      try {
        const { data, error } = await this.supabase.from('users').select('*')
        if (error) throw error
        this.users = data // Populate users data
      } catch (error) {
        console.error('Error fetching users:', error.message)
      }
    },
  },
}
</script>
