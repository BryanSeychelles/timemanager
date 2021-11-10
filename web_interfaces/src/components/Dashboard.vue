<template>
  <v-container class="mt-4">
    <v-container class="text-center mb-8">
      <h2>Bonjour {{this.user.username}},</h2>
      <clockmanager/>
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
      user: []
    }
  },
  mounted (){
    this.getUser(this.$route.params.id)
  },
  methods: {
    getUser (id){
      axios
        .get(this.path + '/' + id)
        .then((response) => {
          this.user = response.data.data
          console.log(response.data.data)
        })
    },
  }
}
</script>

<style>
</style>
