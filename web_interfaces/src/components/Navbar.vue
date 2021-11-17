<template>
  <div>
    <v-app-bar app color="deep-purple lighten-2" class="white--text">
      <v-toolbar-title class="text-uppercase font-weight-bold mr-10">
        Time manager
      </v-toolbar-title>
      <router-link
        class="white--text text-decoration-none mr-6"
        :to="'/users/' + current_user_id"
      >
        <!-- TO DO: CURRENT USER IN URL-->
        <v-btn>Dashboard</v-btn>
      </router-link>
      <router-link
        class="white--text text-decoration-none mr-6"
        to="/users"
        v-if="current_user_role == 'General_Manager'"
      >
        <v-btn>Users</v-btn>
      </router-link>
      <!-- if current user is admin -->
      <router-link
        class="white--text text-decoration-none"
        to="/manage"
        v-if=" current_user_role == 'Manager' || current_user_role == 'General_Manager'">
        <v-btn>Manage</v-btn>
      </router-link>

      <v-spacer></v-spacer>

      <!-- DIALOG FOR ACCOUNT INFORMATIONS -->
      <v-menu
        v-model="menu"
        :close-on-content-click="false"
        :nudge-width="200"
        offset-x
      >
        <template v-slot:activator="{ on, attrs }">
          <v-btn color="orange" dark v-bind="attrs" v-on="on">
            <span>Account</span>
            <v-icon small class="ml-2">fas fa-angle-down</v-icon>
          </v-btn>
        </template>
        <v-card>
          <v-list>
            <v-list-item>
              <v-list-item-content>
                <v-list-item-title>{{
                  this.current_user_username
                }}</v-list-item-title>
                <v-list-item-subtitle>{{
                  this.current_user_email
                }}</v-list-item-subtitle>
                <v-list-item-title
                  class="mt-4"
                  v-if="this.current_user_role == 'General_Manager'"
                  >Role : General Manager</v-list-item-title
                >
                <v-list-item-title
                  class="mt-4"
                  v-if="this.current_user_role == 'Manager'"
                  >Role : Manager</v-list-item-title
                >
                <v-list-item-title
                  class="mt-4"
                  v-if="this.current_user_role == 'Employee'"
                  >Role : Employee</v-list-item-title
                >
              </v-list-item-content>
            </v-list-item>
          </v-list>

          <v-divider></v-divider>

          <v-list>
            <v-list-item class="mt-2">
              <!-- MODAL EDIT USER -->
              <v-dialog v-model="editUserDialog" persistent max-width="600px">
                <template v-slot:activator="{ on, attrs }">
                  <v-btn small color="green" dark v-bind="attrs" v-on="on">
                    <v-icon small class="mr-2">fas fa-edit</v-icon>
                    <span>Edit my account</span>
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
                          <v-row justify="center">
                            <v-col cols="12" sm="5" md="5">
                              <v-text-field
                                v-model="current_user_username"
                                dense
                                outlined
                                required
                                label="Username"
                              ></v-text-field>
                              <v-text-field
                                v-model="current_user_email"
                                dense
                                outlined
                                required
                                label="Email"
                              ></v-text-field>
                            </v-col>
                          </v-row>
                        </v-container>
                      </v-form>
                    </v-container>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                      color="blue darken-1"
                      text
                      v-on:click="closeEditUserDialog()"
                      >Close</v-btn
                    >
                    <v-btn
                      color="green"
                      dark
                      v-on:click="updateUser(current_user_id)"
                      >Edit</v-btn
                    >
                  </v-card-actions>
                </v-card>
              </v-dialog>
            </v-list-item>
          </v-list>

          <v-spacer></v-spacer>

          <v-list>
            <v-list-item>
              <v-list-item-action>
                <v-btn small v-on:click="sign_out()" color="white">
                  <v-icon small color="red" class="mr-2"
                    >fas fa-sign-out-alt</v-icon
                  >
                  <span>Sign out</span>
                </v-btn>
              </v-list-item-action>
            </v-list-item>
          </v-list>

          <v-card-actions>
            <v-spacer></v-spacer>
          </v-card-actions>
        </v-card>
      </v-menu>
    </v-app-bar>
    <v-app class="navMobile">
      <v-app-bar app color="primary" class="white--text">
        <div class="text-center">
          <v-menu offset-y>
            <template v-slot:activator="{ on, attrs }">
              <v-btn color="primary" dark v-bind="attrs" v-on="on">
                Time manager
              </v-btn>
            </template>
            <v-list>
              <v-list-item>
                <router-link
                  class="white--text text-decoration-none mr-2"
                  to="/users/1"
                >
                  <v-btn>Dashboard</v-btn>
                </router-link>
              </v-list-item>
              <v-list-item>
                <router-link
                  class="white--text text-decoration-none mr-6"
                  to="/users"
                  v-if="current_user_role == 'General_Manager'"
                >
                  <v-btn>Users</v-btn>
                </router-link>
              </v-list-item>
              <v-list-item>
                <router-link
                  class="white--text text-decoration-none"
                  to="/manage"
                >
                  <v-btn>Manage</v-btn>
                </router-link>                
              </v-list-item>
            </v-list>            
          </v-menu>          
        </div>
              <v-spacer></v-spacer>

      <!-- DIALOG FOR ACCOUNT INFORMATIONS -->
      <v-menu
        class="accountMobile"
        v-model="menu"
        :close-on-content-click="false"
        :nudge-width="200"
        offset-x
      >
        <template v-slot:activator="{ on, attrs }">
          <v-btn color="orange" dark v-bind="attrs" v-on="on">
            <span>Account</span>
            <v-icon small class="ml-2">fas fa-angle-down</v-icon>
          </v-btn>
        </template>
        <v-card>
          <v-list>
            <v-list-item>
              <v-list-item-content>
                <v-list-item-title>{{
                  this.current_user_username
                }}</v-list-item-title>
                <v-list-item-subtitle>{{
                  this.current_user_email
                }}</v-list-item-subtitle>
                <v-list-item-title
                  class="mt-4"
                  v-if="this.current_user_role == 'General_Manager'"
                  >Role : General Manager</v-list-item-title
                >
                <v-list-item-title
                  class="mt-4"
                  v-if="this.current_user_role == 'Manager'"
                  >Role : Manager</v-list-item-title
                >
                <v-list-item-title
                  class="mt-4"
                  v-if="this.current_user_role == 'Employee'"
                  >Role : Employee</v-list-item-title
                >
              </v-list-item-content>
            </v-list-item>
          </v-list>

          <v-divider></v-divider>

          <v-list>
            <v-list-item class="mt-2">
              <!-- MODAL EDIT USER -->
              <v-dialog v-model="editUserDialog" persistent max-width="600px">
                <template v-slot:activator="{ on, attrs }">
                  <v-btn small color="green" dark v-bind="attrs" v-on="on">
                    <v-icon small class="mr-2">fas fa-edit</v-icon>
                    <span>Edit my account</span>
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
                          <v-row justify="center">
                            <v-col cols="12" sm="5" md="5">
                              <v-text-field
                                v-model="current_user_username"
                                dense
                                outlined
                                required
                                label="Username"
                              ></v-text-field>
                              <v-text-field
                                v-model="current_user_email"
                                dense
                                outlined
                                required
                                label="Email"
                              ></v-text-field>
                            </v-col>
                          </v-row>
                        </v-container>
                      </v-form>
                    </v-container>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                      color="blue darken-1"
                      text
                      v-on:click="closeEditUserDialog()"
                      >Close</v-btn
                    >
                    <v-btn
                      color="green"
                      dark
                      v-on:click="updateUser(current_user_id)"
                      >Edit</v-btn
                    >
                  </v-card-actions>
                </v-card>
              </v-dialog>
            </v-list-item>
          </v-list>

          <v-spacer></v-spacer>

          <v-list>
            <v-list-item>
              <v-list-item-action>
                <v-btn small v-on:click="sign_out()" color="white">
                  <v-icon small color="red" class="mr-2"
                    >fas fa-sign-out-alt</v-icon
                  >
                  <span>Sign out</span>
                </v-btn>
              </v-list-item-action>
            </v-list-item>
          </v-list>

          <v-card-actions>
            <v-spacer></v-spacer>
          </v-card-actions>
        </v-card>
      </v-menu>
      </v-app-bar>
    </v-app>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Navbar",
  data: () => ({
    path: "http://" + process.env.VUE_APP_SERVICE_URL + ":4000/api/users",
    token: localStorage.getItem("user_token"),
    current_user_id: localStorage.getItem("user_id"),
    current_user_role: localStorage.getItem("user_role"),
    current_user_email: localStorage.getItem("user_email"),
    current_user_username: localStorage.getItem("user_username"),
    editUserDialog: "",
    user: [],
    menu: "",
  }),
  methods: {
    getUser(id) {
      axios.get(this.path + "/" + id).then((response) => {
        this.user = response.data.data;
        console.log("user data");
        console.log(response.data.data);
      });
    },
    updateUser(id) {
      axios
        .put(
          this.path + "/" + id,
          {
            user: {
              username: this.newUsername,
              email: this.newEmail,
            },
          },
          {
            headers: { Authorization: `Bearer ${this.token}` },
          }
        )
        .then((response) => {
          console.log(response.data);
          location.reload();
        });
    },
    closeEditUserDialog() {
      this.editUserDialog = false;
      location.reload();
    },
    sign_out() {
      localStorage.removeItem("user_id");
      localStorage.removeItem("user_username");
      localStorage.removeItem("user_email");
      localStorage.removeItem("user_role");
      localStorage.removeItem("user_token");
      this.$router.push("/users/sign_in");
      location.reload();
    },
  },
};
</script>

<style>
.v-application--wrap {
  min-height: 0 !important;
}
@media screen and (max-width: 640px) {
  .accountMobile{
    visibility: hidden;
    display: none;
  }
  [role="menu"] {
    margin-left: -5% !important;
  }
}
@media screen and (min-width: 641px) {
  .navMobile {
    display: none !important;
  }
  .navDekstop {
    display: block !important;
  }
}
body {
  overflow-x: hidden;
}
</style>
