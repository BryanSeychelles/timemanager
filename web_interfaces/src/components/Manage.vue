<template>
  <v-container class="mt-4">
    <v-container class="text-center mb-8">
      <v-container class="d-flex justify-center">
        <p>Manage my team</p>
      </v-container>

      <v-select
        class="select"
        :items="teams"
        v-model="selected"
        item-text="name"
        return-object
        v-on:change="
          getUsersInTeam(selected.id),
            getWorkingtimesByTeam(selected.id, date_actuelle_wt)
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
            <v-btn color="blue darken-1" text v-on:click="closeNewTeamDialog()"
              >Close</v-btn
            >
            <v-btn color="primary" v-on:click="createTeam(current_user_id)"
              >Save</v-btn
            >
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
          <v-card-title>Team :{{ selected.name }}</v-card-title>

          <!-- MODAL ADD USER -->
          <v-dialog v-model="addUserDialog" persistent max-width="600px">
            <template v-slot:activator="{ on, attrs }">
              <v-btn
                color="primary"
                dark
                v-bind="attrs"
                v-on:click="getEmployees()"
                v-on="on"
              >
                + user</v-btn
              >
            </template>
            <v-card>
              <v-card-title>
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

        <br />
        <br />

        <p>Member(s) of Team</p>

        <!-- CARD DES MEMBRES DU TEAM-->

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
            <v-card-subtitle class="mb-2">{{ user.email }}</v-card-subtitle>
            <v-card-actions class="justify-center">
              <v-btn small v-on:click="getUser(user.id)">
                <router-link class="link-router" :to="'/users/' + user.id"
                  >Show</router-link
                >
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-container>
        <br />
        <br />
        <container class="justify-center">
          <v-row>
            <v-col cols="12" sm="6" md="6">
              <p>Total hours of the Team</p>
              <column-chart
                :data="[
                  ['Lundi', parseFloat(this.days_wt.lundi)],
                  ['Mardi', parseFloat(this.days_wt.mardi)],
                  ['Mercredi', parseFloat(this.days_wt.mercredi)],
                  ['Jeudi', parseFloat(this.days_wt.jeudi)],
                  ['Vendredi', parseFloat(this.days_wt.vendredi)],
                ]"
              ></column-chart>
            </v-col>

            <v-col cols="12" sm="6" md="6">
              <p>Average hours of the Team</p>
              <line-chart
                :data="[
                  ['Lundi', parseFloat(this.days_moyenne_wt.lundi)],
                  ['Mardi', parseFloat(this.days_moyenne_wt.mardi)],
                  ['Mercredi', parseFloat(this.days_moyenne_wt.mercredi)],
                  ['Jeudi', parseFloat(this.days_moyenne_wt.jeudi)],
                  ['Vendredi', parseFloat(this.days_moyenne_wt.vendredi)],
                ]"
              ></line-chart>
            </v-col>
          </v-row>
        </container>

        <br />

        <br />
        <br />
        <container class="d-flex justify-center flex-wrap">
          <table border="1">
            <caption>
              <br />
            </caption>
            <colgroup span="1" style="color: red" />
            <colgroup span="3" style="color: blue" />
            <thead>
              <tr>
                <th scope="col" WIDTH="150">Hours/Week</th>
                <th scope="col" WIDTH="150">Total by week</th>
                <th scope="col" WIDTH="150">Average hours</th>
              </tr>
            </thead>
            <tbody border="2">
              <!--<tr v-for="user in users" :key="user.id"> -->
              <tr>
                <th rowspan="2" scope="row">Team</th>
                <td>{{ this.total_semaine_wt }}</td>
                <td>{{ this.total_semaine_moyenne_wt }}</td>
              </tr>
            </tbody>
          </table>
        </container>
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

      users: [],
      employees: [],
      workingtimes: [],
      addUserDialog: null,
      newName: "",
      newTeamDialog: null,
      selected: "",
      selectedEmployee: "",
      teams: [],

      //WorkingTimes variables
      path_wt: "http://localhost:4000/api/workingtimes",
      user_id: "",
      days_wt: {
        lundi: "00:00",
        mardi: "00:00",
        mercredi: "00:00",
        jeudi: "00:00",
        vendredi: "00:00",
      },
      days_moyenne_wt: {
        lundi: "00:00",
        mardi: "00:00",
        mercredi: "00:00",
        jeudi: "00:00",
        vendredi: "00:00",
      },
      day_wt: "",
      heures_jour_wt: "00:00",
      total_semaine_wt: "00:00",
      total_semaine_moyenne_wt: 0.0,
      newDateStart_wt: "",
      newDateEnd_wt: "",
      size_workingtimes: "",
      startDate_wt: "",
      endDate_wt: "",
      date_actuelle_wt: "",
      date_actuelle_2_wt: "",
      starthour_wt: "",
      endhour_wt: "",
      rest_wt: "00:00",
      test_1: 0,
      test_2: "",
      //Commun variables (workingtime et manage)
      current_user_id: localStorage.getItem("user_id"),
      current_user_role: localStorage.getItem("user_role"),
    };
  },
  mounted() {
    this.date_actuelle_now();
    this.getTeams(this.current_user_id);
    //this.sommer_workingtimes(5,'2021-11-19');
  },
  methods: {
<<<<<<< HEAD
    getEmployees() {
      axios
        .get("http://" + process.env.VUE_APP_SERVICE_URL + ":4000/api/users/employees", {
          headers: { Authorization: `Bearer ${this.token}` },
        })
        .then((response) => {
          console.log(response.data.data);
          this.employees = response.data.data;
        });
=======
    convertir_jourstotal_pour_joursmoyennes(size) {
      var size2 = size - 1;
      this.days_moyenne_wt.lundi =
        parseFloat(this.days_wt.lundi) / parseFloat(size2);
      this.days_moyenne_wt.mardi =
        parseFloat(this.days_wt.mardi) / parseFloat(size2);
      this.days_moyenne_wt.mercredi =
        parseFloat(this.days_wt.mercredi) / parseFloat(size2);
      this.days_moyenne_wt.jeudi =
        parseFloat(this.days_wt.jeudi) / parseFloat(size2);
      this.days_moyenne_wt.vendredi =
        parseFloat(this.days_wt.vendredi) / parseFloat(size2);
>>>>>>> master
    },

    m_trouver_days(date) {
      var date_format = new Date(date);
      this.day_wt = date_format.getDay();
    },
    sommer_workingtimes(size, date) {
      this.m_trouver_days(date);
      var jour_counter = this.day_wt;
      var co = 1;

      for (var ii = jour_counter; ii >= 0; ii--) {
        this.test_1 = size;
        for (var i = 0; i < size; i++) {
          this.test_2 = i;
          this.startDate_wt = this.workingtimes[i].start;
          this.endDate_wt = this.workingtimes[i].end;
          var start_Date_format = this.startDate_wt.substr(0, 10);
          date = this.date_actuelle_wt;
          this.test_1 = 11;
          if (date === start_Date_format) {
            this.starthour_wt = this.startDate_wt.substr(11, 5);
            this.endhour_wt = this.endDate_wt.substr(11, 5);
            this.resterHeures(this.starthour_wt, this.endhour_wt);
            this.sommerHeures(this.heures_jour_wt, this.rest_wt);
            this.test_1 = -1;
            switch (ii) {
              case 1:
                this.days_wt.lundi = parseFloat(this.heures_jour_wt);
                break;
              case 2:
                this.days_wt.mardi = parseFloat(this.heures_jour_wt);
                break;
              case 3:
                this.days_wt.mercredi = parseFloat(this.heures_jour_wt);
                break;
              case 4:
                this.days_wt.jeudi = parseFloat(this.heures_jour_wt);
                break;
              case 5:
                this.days_wt.vendredi = parseFloat(this.heures_jour_wt);
                break;
            }
          }
        }
        this.rester_date(co);
        co++;
        this.date_convertion_nouvelle(this.date_actuelle_2_wt);
        this.heures_jour_wt = "00:00";
        this.convertir_jourstotal_pour_joursmoyennes(size);
      }
      this.total_semaine_wt =
        parseFloat(this.days_wt.lundi) +
        parseFloat(this.days_wt.mardi) +
        parseFloat(this.days_wt.mercredi) +
        parseFloat(this.days_wt.jeudi) +
        parseFloat(this.days_wt.vendredi);

      this.total_semaine_moyenne_wt =
        parseFloat(this.total_semaine_wt) / parseFloat(size - 1);
    },

    sommerHeures_totalsemaine(heure1, heure2) {
      var Minutes1 = parseInt(heure1.substr(3, 2));
      var Heures1 = parseInt(heure1.substr(0, 2));
      var Minutes2 = parseInt(heure2.substr(3, 2));
      var Heures2 = parseInt(heure2.substr(0, 2));
      var Minutes_passes = Minutes2 + Minutes1;
      var Heures_passes = Heures2 + Heures1;
      if (Minutes_passes > 59) {
        Heures_passes++;
        Minutes_passes = Minutes_passes - 60;
      }
      var heures = Heures_passes.toString();
      var minutes = Minutes_passes.toString();
      if (heures.length < 2) {
        heures = "0" + heures;
      }
      if (minutes.length < 2) {
        minutes = "0" + minutes;
      }
      this.total_semaine_wt = heures.toString() + "." + minutes.toString();
    },

    sommerHeures(heure1, heure2) {
      var Minutes1 = parseInt(heure1.substr(3, 2));
      var Heures1 = parseInt(heure1.substr(0, 2));
      var Minutes2 = parseInt(heure2.substr(3, 2));
      var Heures2 = parseInt(heure2.substr(0, 2));
      var Minutes_passes = Minutes2 + Minutes1;
      var Heures_passes = Heures2 + Heures1;
      if (Minutes_passes > 59) {
        Heures_passes++;
        Minutes_passes = Minutes_passes - 60;
      }
      var heures = Heures_passes.toString();
      var minutes = Minutes_passes.toString();
      if (heures.length < 2) {
        heures = "0" + heures;
      }
      if (minutes.length < 2) {
        minutes = "0" + minutes;
      }
      this.heures_jour_wt = heures.toString() + "." + minutes.toString();
    },
    resterHeures(starthour, endhour) {
      var debut = starthour;
      var fin = endhour;
      var debutMinutes = parseInt(debut.substr(3, 2));
      var debutHeures = parseInt(debut.substr(0, 2));
      var finMinutes = parseInt(fin.substr(3, 2));
      var finHeures = parseInt(fin.substr(0, 2));
      var Minutes_passes = finMinutes - debutMinutes;
      var Heures_passes = finHeures - debutHeures;
      if (Minutes_passes < 0) {
        Heures_passes--;
        Minutes_passes = 60 + Minutes_passes;
      }
      var heures = Heures_passes.toString();
      var minutes = Minutes_passes.toString();
      if (heures.length < 2) {
        heures = "0" + heures;
      }
      if (minutes.length < 2) {
        minutes = "0" + minutes;
      }
      this.rest_wt = heures + ":" + minutes;
    },
    rester_date(monto) {
      var date2 = new Date();
      date2.setDate(date2.getDate() - monto);
      this.date_actuelle_2_wt = date2;
    },
    date_actuelle_now() {
      var jour = "";
      var mois = "";
      var annee = "";
      const tiempoTranscurrido = Date.now();
      const hoy = new Date(tiempoTranscurrido);
      jour = hoy.toDateString().substr(8, 2);
      annee = hoy.toDateString().substr(11, 4);
      switch (hoy.toDateString().substr(4, 3)) {
        case "Jan":
          mois = "01";
          break;
        case "Feb":
          mois = "02";
          break;
        case "Mar":
          mois = "03";
          break;
        case "Apr":
          mois = "04";
          break;
        case "May":
          mois = "05";
          break;
        case "Jun":
          mois = "06";
          break;
        case "Jul":
          mois = "07";
          break;
        case "Aug":
          mois = "08";
          break;
        case "Sep":
          mois = "09";
          break;
        case "Oct":
          mois = "10";
          break;
        case "Nov":
          mois = "11";
          break;
        case "Dec":
          mois = "12";
          break;
      }
      this.date_actuelle_wt = annee + "-" + mois + "-" + jour;
    },
    date_convertion_nouvelle(date_convertion) {
      var jour = "";
      var mois = "";
      var annee = "";
      const hoy = new Date(date_convertion);
      jour = hoy.toDateString().substr(8, 2);
      annee = hoy.toDateString().substr(11, 4);
      switch (hoy.toDateString().substr(4, 3)) {
        case "Jan":
          mois = "01";
          break;
        case "Feb":
          mois = "02";
          break;
        case "Mar":
          mois = "03";
          break;
        case "Apr":
          mois = "04";
          break;
        case "May":
          mois = "05";
          break;
        case "Jun":
          mois = "06";
          break;
        case "Jul":
          mois = "07";
          break;
        case "Aug":
          mois = "08";
          break;
        case "Sep":
          mois = "09";
          break;
        case "Oct":
          mois = "10";
          break;
        case "Nov":
          mois = "11";
          break;
        case "Dec":
          mois = "12";
          break;
      }
      this.date_actuelle_wt = annee + "-" + mois + "-" + jour;
      //this.date_actuelle = "2021-11-10";
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

    getEmployees() {
      axios
        .get("http://localhost:4000/api/users/employees", {
          headers: { Authorization: `Bearer ${this.token}` },
        })
        .then((response) => {
          console.log(response.data.data);
          this.employees = response.data.data;
        });
    },
    //obtiene this.users<=
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

    getWorkingtimesByTeam(team_id, date) {
      axios
        .get(this.path + "/" + team_id + "/workingtimes", {
          headers: { Authorization: `Bearer ${this.token}` },
        })
        .then((response) => {
          console.log(response.data.data);
          this.workingtimes = response.data.data;
          this.sommer_workingtimes(this.workingtimes.length, date);
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
