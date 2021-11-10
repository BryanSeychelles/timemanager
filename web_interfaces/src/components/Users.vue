<!-- FOR ADMIN -->

<template>
  <div>

    <div class="d-flex justify-center mt-10">
      <!-- MODAL NEW USER -->
      <v-dialog v-model="createUserDialog" persistent max-width="600px">
        <template v-slot:activator="{ on, attrs }">
          <v-btn color="primary" dark v-bind="attrs" v-on="on">New user</v-btn>
        </template>
        <v-card>
          <v-card-title justify="center">
            <span class="text-h5">New user</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-form>
                <v-container>
                  <v-row justify="center" >
                    <v-col cols="1" sm="5" md="5">
                      <v-text-field v-model="newUsername" outlined dense required label="Username"></v-text-field>
                      <v-text-field v-model="newEmail" outlined dense required label="Email"></v-text-field>
                      <v-text-field v-model="newPassword" type="password" outlined dense required label="Password"></v-text-field>
                      <v-text-field v-model="newPasswordConfirmation" type="password" outlined dense required label="Password Confirmation"></v-text-field>
                    </v-col>
                  </v-row>
                </v-container>
              </v-form>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text v-on:click="closeNewUserDialog()">Close</v-btn>
            <v-btn color="primary" v-on:click="createUser()">Save</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </div>

    <v-row justify="center" class="mt-4">
      <v-simple-table>
          <thead>
            <tr>
              <th class="text-left">Username</th>
              <th class="text-left">Email</th>
              <th class="text-left">Role</th>
            </tr>
          </thead>
          <tbody>
            <tr class="align-center" v-for="user in users" :key="user.id">
              <td>{{user.username}}</td>
              <td>{{user.email}}</td>
              <td>{{user.role}}</td>
              <v-container class="align-center">
                <v-btn small class="ml-2" v-on:click="getUser(user.id)">
                  <router-link class="link-router" :to="'/users/' + user.id">Show</router-link>
                </v-btn>

                <!-- MODAL EDIT USER -->
                <v-dialog v-model="editUserDialog" persistent max-width="600px">
                  <template v-slot:activator="{ on, attrs }">
                    <v-btn class="mx-2" small color="green" dark v-bind="attrs" v-on="on">
                      <v-icon small class="mr-2">fas fa-edit</v-icon>
                      <span>Edit</span>
                    </v-btn>
                  </template>
                  <v-card>
                    <v-card-title justify="center">
                      <span class="text-h5">Edit user</span>
                    </v-card-title>
                    <v-card-text>
                      <v-container>
                        <v-form>
                          <v-container>
                            <v-row justify="center" >
                              <v-col cols="1" sm="5" md="5">
                                <v-text-field v-model="user.username" outlined required label="Username"></v-text-field>
                                <v-text-field v-model="user.email" outlined required label="Email"></v-text-field>
                              </v-col>
                            </v-row>
                          </v-container>
                        </v-form>
                      </v-container>
                    </v-card-text>
                    <v-card-actions>
                      <v-spacer></v-spacer>
                      <v-btn color="blue darken-1" text v-on:click="closeEditUserDialog()">Close</v-btn>
                      <v-btn color="green" dark v-on:click="updateUser(user.id)">Edit</v-btn>
                    </v-card-actions>
                  </v-card>
                </v-dialog>

                <v-dialog max-width="500">
                  <template v-slot:activator="{ on, attrs }">
                    <v-btn small color="error" v-bind="attrs" v-on="on">
                      <v-icon small class="mr-2">fas fa-trash-alt</v-icon>
                      <span>Delete user</span>
                    </v-btn>
                  </template>
                  <template v-slot:default="dialog">
                    <v-card>
                      <v-toolbar color="error" dark>Delete user</v-toolbar>
                      <v-card-text>
                        <div class="text-p pa-12">Are u sure you want to delete this user ?</div>
                      </v-card-text>
                      <v-card-actions class="justify-end">
                        <v-btn text @click="dialog.value = false">Cancel</v-btn>
                        <v-btn small v-on:click="deleteUser(user.id)" color="error">Yes</v-btn>
                      </v-card-actions>
                    </v-card>
                  </template>
                </v-dialog>
                <v-btn small v-if="user.role == 'Employee'" v-on:click="promote(user.id)" class="ml-2" color="yellow">Promote</v-btn>
              </v-container>
            </tr>
        </tbody>
      </v-simple-table>
    </v-row>

  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Users',
  data () {
    return {
      users: [],
      createUserDialog: '',
      editUserDialog: '',
      path: 'http://localhost:4000/api/users',
      user: { email: 'test@gmail.com', username: 'test' },
      newUsername: '',
      newEmail: '',
      newPassword: '',
      newPasswordConfirmation: '',
      userId: 3 //current_user in future
    }
  },
  mounted (){
    this.getAllUsers()
  },
  methods: {
    getAllUsers (){
      axios
        .get(this.path + '/all')
        .then((response) => {
          console.log(response.data.data)
          this.users = response.data.data
        })
        .catch(err => console.log(err.message))
    },
    getUserById (){
      axios
        .get(this.path + '/' + this.userId)
        .then((response) => {
          console.log(response.data)
        })
    },
    getUsersByEmailAndUsername () {
      axios
        .get(this.path + '?email=' + this.user.email + '&username=' + this.user.username)
        .then((response) => {
          this.users = response.data.data
        })
    },
    createUser () {
      axios
        .post(this.path, {
          user: {
            username: this.newUsername,
            email: this.newEmail,
            password: this.newPassword,
            password_confirmation: this.newPasswordConfirmation
          }
        })
        .then((response) => {
          console.log(response.data)
          location.reload()
        })
        .catch(err => console.log(err.message))
    },
    updateUser (id) {
      axios
        .put(this.path + '/' + id, {
          user: {
            username: this.newUsername,
            email: this.newEmail
          }
        })
        .then((response) => {
          console.log(response.data)
          location.reload()
        })
    },
    deleteUser (id) {
      axios
        .delete(this.path + '/' + id)
        .then((response) => {
          console.log(response)
          location.reload()
        })
    },
    promote (id){
      axios
        .put(this.path + '/' + id + '/promote', {
          user: {
            role: 1
          }
        })
        .then((response) => {
          console.log(response.data)
          location.reload()
        })
        .catch(err => console.log(err.message))
    },
    closeEditUserDialog (){
      this.editUserDialog = false
      location.reload()
    },
    closeNewUserDialog (){
      this.newUserDialog = false
      location.reload()
    },
  }
}
</script>

<style scoped>
  div #select {
    color: #6a66d8;
    font-size: 40px;
  }

  .create-user{
    width:10%;
    display: flex;
    flex-direction: column;
  }

  .create-user input{
    height:25px;
  }

  .link-router{
    text-decoration: none;
  }
</style>
