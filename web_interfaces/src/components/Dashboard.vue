<template>
  <v-container class="mt-4">
    <v-container class="text-center mb-8">
      <h2>Dashboard de {{this.user.username}}</h2>
      <clockmanager v-if="this.current_user_id == this.$route.params.id"/>
    </v-container>
    <workingtimes/>
  </v-container>
</template>

<script>
import axios from 'axios'
import Workingtimes from './WorkingTimes.vue'
import Clockmanager from './ClockManager.vue'

export default {
  name: 'Dashboard',
  components: { Workingtimes, Clockmanager },
  data () {
    return {
      path: "http://localhost:4000/api/users",
      token: localStorage.getItem("user_token"),
      current_user_id: localStorage.getItem("user_id"),
      current_user_role: localStorage.getItem("user_role"),
      current_user_username: localStorage.getItem("user_username"),
      user: [],
    }
  },
  mounted() {
    this.getUserById(this.$route.params.id)
  },
  updated() {
    this.getUserById(this.$route.params.id)
    console.log("updated");
  },
  methods: {
    getUserById (id) {
      axios
        .get(this.path + '/' + id, {
          headers: { Authorization: `Bearer ${this.token}` },
        })
        .then((response) => {
          this.user = response.data.data
          console.log(response.data)
        })
    }
  }
}
</script>

<style>
</style>
