<template>
  <v-container class="mt-4">
    <v-container class="text-center mb-8">
      <v-container class="d-flex justify-center">
        <h2>Manage my teams</h2>
      </v-container>

      <v-select
        class="select"
        :items="teams"
        v-model="selected"
        item-text="name"
        return-object
        v-on:change="
          getUsersInTeam(selected.id), getWorkingtimesByTeam(selected.id)
        "
        label="Select a team"
      />

      <!-- MODAL NEW TEAM -->
      <v-dialog v-model="newTeamDialog" persistent max-width="600px">
        <template v-slot:activator="{ on, attrs }">
          <v-btn color="primary" dark v-bind="attrs" v-on="on">New team</v-btn>
        </template>
        <v-card>
          <v-card-title justify="center">
            <span class="text-h5">New team</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-form>
                <v-container>
                  <v-row justify="center">
                    <v-col cols="12" sm="5" md="5">
                      <v-text-field
                        v-model="newName"
                        outlined
                        dense
                        required
                        label="Name"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                </v-container>
              </v-form>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text v-on:click="closeNewTeamDialog()">Close</v-btn>
            <v-btn color="primary" v-on:click="createTeam(current_user_id)">Save</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <v-card :elevation="6" class="ma-4 pa-8" v-if="this.selected">
        <v-container
          class="
            d-flex
            teal
            flex-md-row flex-sm-column
            align-center
            lighten-2
            white--text
          "
        >
          <v-card-title>{{ selected.name }}</v-card-title>

          <!-- MODAL ADD USER -->
          <v-dialog v-model="addUserDialog" persistent max-width="600px">
            <template v-slot:activator="{ on, attrs }">
              <v-btn
                color="primary"
                dark
                v-bind="attrs"
                v-on:click="getEmployees()"
                v-on="on"
                >Add user</v-btn
              >
            </template>
            <v-card>
              <v-card-title justify="center">
                <span class="text-h5">Add user</span>
              </v-card-title>
              <v-card-text>
                <v-container>
                  <v-form>
                    <v-container>
                      <v-row justify="center">
                        <v-col cols="12" sm="12" md="12">
                          <v-select
                            class="select"
                            :items="employees"
                            dense
                            v-model="selectedEmployee"
                            item-text="username"
                            return-object
                            label="Select a user"
                          />
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
                  v-on:click="closeAddUserDialog()"
                  >Close</v-btn
                >
                <v-btn
                  color="primary"
                  v-on:click="addUserToTeam(selected.id, selectedEmployee.id)"
                  >Save</v-btn
                >
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-container>
        <v-container class="d-flex justify-center flex-wrap">
          <v-card
            class="ma-4"
            width="250"
            :elevation="6"
            v-for="user in users"
            :key="user.id"
          >
            <v-card-title class="justify-center">{{
              user.username
            }}</v-card-title>
            <v-card-subtitle class="mb-2">{{user.email}}</v-card-subtitle>
            <v-card-actions class="justify-center">
              <v-btn small v-on:click="getUser(user.id)">
                <router-link class="link-router" :to="'/users/' + user.id"
                  >Show</router-link
                >
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-container>
        <!-- WORKINGTIMES -->
      </v-card>
    </v-container>
  </v-container>
</template>

<script>
import axios from "axios";

export default {
  name: "Manage",
  data() {
    return {
      path: "http://" + process.env.VUE_APP_SERVICE_URL + ":4000/api/teams",
      token: localStorage.getItem("user_token"),
      current_user_id: localStorage.getItem("user_id"),
      current_user_role: localStorage.getItem("user_role"),
      users: [],
      employees: [],
      workingtimes: [],
      addUserDialog: null,
      newName: "",
      newTeamDialog: null,
      selected: "",
      selectedEmployee: "",
      teams: []
    };
  },
  mounted() {
    this.getTeams(this.current_user_id);
  },
  methods: {
    getEmployees() {
      axios
        .get("http://" + process.env.VUE_APP_SERVICE_URL + ":4000/api/users/employees", {
          headers: { Authorization: `Bearer ${this.token}` },
        })
        .then((response) => {
          console.log(response.data.data);
          this.employees = response.data.data;
        });
    },
    getTeams(manager_id) {
      axios
        .get(this.path + "/" + manager_id, {
          headers: { Authorization: `Bearer ${this.token}` },
        })
        .then((response) => {
          console.log(response.data.data);
          this.teams = response.data.data;
        })
        .catch((err) => console.log(err.message));
    },
    getUsersInTeam(team_id) {
      axios
        .get(this.path + "/" + team_id + "/users", {
          headers: { Authorization: `Bearer ${this.token}` },
        })
        .then((response) => {
          console.log(response.data.data);
          this.users = response.data.data;
        });
    },
    getWorkingtimesByTeam(team_id) {
      axios
        .get(this.path + "/" + team_id + "/workingtimes", {
          headers: { Authorization: `Bearer ${this.token}` },
        })
        .then((response) => {
          console.log(response.data.data);
          this.workingtimes = response.data.data;
        });
    },
    getWorkingtimesAndUsersByTeam(team_id) {
      getUsersInTeam(team_id);
      getWorkingtimesByTeam(team_id);
    },
    createTeam() {
      axios
        .post(
          this.path + "/" + this.current_user_id,
          {
            team: {
              name: this.newName,
            },
          },
          {
            headers: { Authorization: `Bearer ${this.token}` },
          }
        )
        .then((response) => {
          console.log(response.data);
          location.reload();
        })
        .catch((err) => console.log(err.message));
    },
    addUserToTeam(team_id, user_id) {
      axios
        .post(
          this.path + "/",
          {
            user_team: {
              user_id: user_id,
              team_id: team_id,
            },
          },
          {
            headers: { Authorization: `Bearer ${this.token}` },
          }
        )
        .then((response) => {
          console.log(response.data);
          location.reload();
        })
        .catch((err) => console.log(err.message));
    },
    closeNewTeamDialog() {
      this.newTeamDialog = false;
      location.reload();
    },
    closeAddUserDialog() {
      this.addUserDialog = false;
      location.reload();
    },
  },
};
</script>

<style>
.select {
  width: 40%;
  margin: 50px auto 20px auto;
}
</style>
