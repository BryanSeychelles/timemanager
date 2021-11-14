<template>
  <v-container class="mt-4">
    <v-container class="text-center mb-8">
      <h2>DashBoard de {{this.user.username}}</h2>
      <clockmanager v-if="this.current_user.id == this.$route.params.id"/>
      <v-btn class="ma-4" color="green" dark elevation="2" x-large>Start</v-btn>
      <v-btn class="ma-4" color="red" dark elevation="2" x-large>End</v-btn>
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
      path: 'http://localhost:4000/api/users',
      user: [],
      token: localStorage.getItem("user_token"),
      current_user: localStorage.getItem("user")
    }
  },
  mounted () {
    this.getUserByToken()
  },
  methods: {
    /*getUser (id){
      axios
        .get(this.path + '/' + id)
        .then((response) => {
          this.user = response.data.data
          console.log(response.data.data)
          locate.reload()
        })
    },*/
    async getUserByToken() {
      const response = await axios
        .get("http://localhost:4000/api/users/", {
          headers: { Authorization: `Bearer ${this.token}` },
        })
        .catch((error) => console.log(error));
      this.user = response.data;
      console.log("USER: ");
      console.log(this.user);
      console.log(this.user.id);
    }
  }
}
</script>

<style>
</style>
