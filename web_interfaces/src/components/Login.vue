<template>
  <v-card class="elevation-12">
    <v-card-title>Login</v-card-title>
    <v-card-text>
      <v-form>
        <v-text-field v-model="email" label="email"></v-text-field>
        <v-text-field
          v-model="password"
          label="password"
          :append-icon="value ? 'mdi-eye' : 'mdi-eye-off'"
          @click:append="value = !value"
          :type="value ? 'password' : 'text'"
        ></v-text-field>
        <v-col v-if="connection_error">
          <p :style="{ color: '#f21e7e' }">The user does not exist.</p>
        </v-col>
      </v-form>
    </v-card-text>
    <v-card-actions>
      <v-spacer></v-spacer>
      <v-btn color="primary" @click="login()">Login</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import axios from "axios";
import User from "./Users.vue";

export default {
  name: "Login",
  data() {
    return {
      path: "http://localhost:4000/api/users/sign_in",
      token: "",
      redirect_path: "/users/",
      connection_error: false,
      value: true,
      user: null,
      email: "foo@bar.com",
      password: "12345678"
      /*rule_email: [
        e => !!e || "Required",
        e => /.+@.+\..+/.test(e) || "E-mail must be valid"
      ],
      rule_password: [
        p => !!p || 'Password is required',
        p => (p && p.length >= 8) || 'Password must have 8+ characters',
        p => /(?=.*[A-Z])/.test(p) || 'Must have one uppercase character',
        p => /(?=.*\d)/.test(p) || 'Must have one number'
      ]*/
    };
  },
  methods: {
    async sign_in() {
      console.log(this.email);
      console.log(this.password);
      const response = await axios
        .post(this.path, {
          email: this.email,
          password: this.password,
        })
        .catch((err) => {
          this.connection_error = true;
          console.log(err.message);
        });
      this.token = response.data.jwt;
      console.log("TOKEN: ");
      console.log(this.token);
    },
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
    },
    async login() {
      await this.sign_in();
      await this.getUserByToken();
      if (this.user != null) {
        this.$router.push("/users/" + this.user.id);
        localStorage.setItem("user_token", this.token);
        localStorage.setItem("user_id", this.user.id);
        localStorage.setItem("user_email", this.user.email);
        localStorage.setItem("user_username", this.user.username);
        localStorage.setItem("user_role", this.user.role);
      }
    },
  },
};
</script>
