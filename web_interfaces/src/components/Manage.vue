<template>
  <v-container class="mt-4">
    <v-container class="text-center mb-8">
      <v-container class="d-flex justify-center">
        <h2>Manage my teams</h2>

        <!-- MODAL NEW TEAM -->
        <v-dialog v-model="createTeamDialog" persistent max-width="600px">
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
                    <v-row justify="center" >
                      <v-col cols="12" sm="5" md="5">
                        <v-text-field v-model="newName" outlined dense required label="Name"></v-text-field>
                      </v-col>
                    </v-row>
                  </v-container>
                </v-form>
              </v-container>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text v-on:click="closeNewTeamDialog()">Close</v-btn>
              <v-btn color="primary" v-on:click="createTeam(userId)">Save</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-container>

      <v-select class="select" :items="teams" v-model="selected" item-text="name" return-object v-on:change="getUsersInTeam(selected.id)" label="Select a team"/>
      <v-card :elevation="6" class="ma-4 pa-8">
        <v-container class="d-flex teal align-center lighten-2 white--text">
          <v-card-title>{{selected.name}}</v-card-title>

          <!-- MODAL NEW TEAM -->
          <v-dialog v-model="createTeamDialog" persistent max-width="600px">
            <template v-slot:activator="{ on, attrs }">
              <v-btn color="primary" dark v-bind="attrs" v-on="on">Add user</v-btn>
            </template>
            <v-card>
              <v-card-title justify="center">
                <span class="text-h5">Add user</span>
              </v-card-title>
              <v-card-text>
                <v-container>
                  <v-form>
                    <v-container>
                      <v-row justify="center" >
                        <v-col cols="12" sm="5" md="5">
                          <v-text-field v-model="newName" outlined dense required label="Name"></v-text-field>
                        </v-col>
                      </v-row>
                    </v-container>
                  </v-form>
                </v-container>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="blue darken-1" text v-on:click="closeNewTeamDialog()">Close</v-btn>
                <v-btn color="primary" v-on:click="createTeam(userId)">Save</v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-container>
        <v-container class="mt-4 d-flex justify-space-around flex-wrap">
          <v-card class="mb-4" width="250" :elevation="6" v-for="user in users" :key="user.id">
            <v-card-title class="justify-center">{{user.username}}</v-card-title>
            <v-card-actions>
              <v-btn small class="ml-2" v-on:click="getUser(user.id)">
                <router-link class="link-router" :to="'/users/' + user.id">Show</router-link>
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-container>
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
      selected: '',
      teams: [],
      current_user: [],
      users: [],
      createTeamDialog: null,
      newName: '',
      newTeamDialog: null,
      path: 'http://localhost:4000/api/teams',
      userId: 1 // current_user.id in future
    };
  },
  mounted() {
    this.getTeams(this.userId);
  },
  methods: {
    getTeams(manager_id) {
      axios
        .get(this.path + "/" + manager_id)
        .then((response) => {
          console.log(response.data.data);
          this.teams = response.data.data;
        })
        .catch((err) => console.log(err.message));
    },
    getUsersInTeam(team_id) {
      axios
        .get(this.path + '/' + team_id + '/users')
        .then((response) => {
          console.log(response.data.data)
          this.users = response.data.data
        })
    },
    createTeam(manager_id) {
      axios
        .post(this.path + "/" + manager_id, {
          team: {
            name: this.newName
          },
        })
        .then((response) => {
          console.log(response.data);
          location.reload();
        })
        .catch((err) => console.log(err.message));
    },
    closeNewTeamDialog (){
      this.newTeamDialog = false
      location.reload()
    }
  },
};
</script>

<style>
  .select{
    width:40%;
    margin: 50px auto 20px auto;
  }
</style>