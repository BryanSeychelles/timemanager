<template>
  <v-app>
    <v-app-bar app color="primary" class="white--text">
      <v-toolbar-title class="text-uppercase font-weight-bold mr-10">
        Time manager
      </v-toolbar-title>
      <v-toolbar-items class="d-flex justify-space-around align-center">
        <router-link class="white--text text-decoration-none mr-6" to="/users/1">
          <v-btn>Dashboard</v-btn>
        </router-link>
        <router-link class="white--text text-decoration-none mr-6" to="/users">
          <v-btn>Users</v-btn>
        </router-link> <!-- if current user is admin -->
        <router-link class="white--text text-decoration-none" to="/manage">
          <v-btn>Manage</v-btn>
        </router-link>
      </v-toolbar-items>

      <v-spacer></v-spacer>

      <!-- DIALOG FOR ACCOUNT INFORMATIONS -->
      <v-menu v-model="menu" :close-on-content-click="false" :nudge-width="200" offset-x>
      <template v-slot:activator="{ on, attrs }">
        <v-btn color="green" dark v-bind="attrs" v-on="on">
        <span>Account</span>
        <v-icon small class="ml-2">fas fa-angle-down</v-icon>
        </v-btn>
      </template>
      <v-card>
        <v-list>
          <v-list-item>
            <v-list-item-content>
              <v-list-item-title>{{this.user.username}}</v-list-item-title>
              <v-list-item-subtitle>{{this.user.email}}</v-list-item-subtitle>
              <v-list-item-title class="mt-4">{{this.user.role}}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>

        <v-divider></v-divider>

        <v-list>
          <v-list-item>
            <v-list-item-title>Edit my account</v-list-item-title>
          </v-list-item>
          <v-list-item class="mt-2">
            <v-form>
              <v-text-field outlined dense required clearable label="Username"></v-text-field>
              <v-text-field outlined dense required clearable label="Email"></v-text-field>
              <v-btn color="green" small dark v-on:click="updateUser(user.id)">
                <v-icon small class="mr-2">fas fa-save</v-icon>
                <span>Save</span>
              </v-btn>
            </v-form>
          </v-list-item>
        </v-list>

        <v-spacer></v-spacer>

        <v-list>
          <v-list-item>
            <v-list-item-action>
              <v-btn small v-on:click="" color="white">
                <v-icon small color="red" class="mr-2">fas fa-sign-out-alt</v-icon>
                <span>Sign out</span>
              </v-btn>
            </v-list-item-action>
          </v-list-item>
        </v-list>

        <v-spacer></v-spacer>

        <v-list>
          <v-list-item>
            <v-list-item-action>
              <v-dialog max-width="500">
                <template v-slot:activator="{ on, attrs }">
                  <v-btn small color="error" v-bind="attrs" v-on="on">
                    <v-icon small class="mr-2">fas fa-trash-alt</v-icon>
                    <span>Delete my account</span>
                  </v-btn>
                </template>
                <template v-slot:default="dialog">
                  <v-card>
                    <v-toolbar color="error" dark>Delete my account</v-toolbar>
                    <v-card-text>
                      <div class="text-p pa-12">Are u sure you want to delete your account ?</div>
                    </v-card-text>
                    <v-card-actions class="justify-end">
                      <v-btn text @click="dialog.value = false">Cancel</v-btn>
                      <v-btn small v-on:click="deleteUser(user.id)" color="error">Yes</v-btn>
                    </v-card-actions>
                  </v-card>
                </template>
              </v-dialog>
            </v-list-item-action>
          </v-list-item>
        </v-list>

        <v-card-actions>
          <v-spacer></v-spacer>
          </v-card-actions>
        </v-card>
      </v-menu>
    </v-app-bar>

    <v-main>
      <router-view/>
    </v-main>
  </v-app>
</template>

<script>
import axios from 'axios'

export default {
  name: 'App',
  data: () => ({
    path: 'http://localhost:4000/api/users',
    userId: 1,
    user: []
  }),
  mounted (){
    this.getUser(this.userId) // TO DO : current_user_id
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
};
</script>
