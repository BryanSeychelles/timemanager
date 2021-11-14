<template>
  <v-app>
    <navbar v-if="getLocalStorage()"/>
    <v-main>
      <router-view/>
    </v-main>
  </v-app>
</template>

<script>
import axios from 'axios'
import Navbar from './components/Navbar.vue'

export default {
  name: 'App',
  components: { Navbar },
  data: () => ({
    token: localStorage.getItem("user_token"),
  }),
  mounted() {

  },
  methods: {
    getLocalStorage() {
      return localStorage.getItem("user_id")
    }
  }
};
</script>
