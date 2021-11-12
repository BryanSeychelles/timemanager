<template >
  <div>
    <v-container>
      <h2 class="text-center mb-4">Statistiques</h2>
      <v-row justify="center" class="align-center">
        <!-- MODAL NEW WORKINGTIME -->
        <v-container justify="center">
          <v-dialog
            v-model="createWorkingTimeDialog"
            class="mr-4"
            persistent
            max-width="600px"
          >
            <template v-slot:activator="{ on, attrs }">
              <v-btn
                color="primary"
                dark
                v-bind="attrs"
                v-on="on"
                @click="getWorkingTimes()"
                >New Workingtime
              </v-btn>
            </template>

            <v-card>
              <v-card-title justify="center">
                <span class="text-h5">New Workingtime</span>
              </v-card-title>
              <v-card-text>
                <v-container>
                  <v-form>
                    <v-container>
                      <v-row justify="center">
                        <v-col cols="1" sm="5" md="5">
                          <input
                            type="datetime-local"
                            v-model="newDateStart"
                            placeholder="Start"
                          />
                          <input
                            type="datetime-local"
                            v-model="newDateEnd"
                            placeholder="End"
                          />
                        </v-col>
                      </v-row>
                    </v-container>
                  </v-form>
                </v-container>
              </v-card-text>

              <v-card-actions>
                <v-btn
                  color="blue darken-1"
                  text
                  v-on:click="closeNewWorkingTimeDialog()"
                  >Close</v-btn
                >
                <v-btn
                  color="primary"
                  v-on:click="
                    createWorkingTime(
                      $route.params.user_id,
                      newDateStart,
                      newDateEnd,
                      ''
                    )
                  "
                  >Save</v-btn
                >
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-container>

        <v-row>
          <v-col cols="1" sm="5" md="5">
            <pie-chart
              :data="[
                ['Lundi', this.days.lundi],
                ['Mardi', this.days.mardi],
                ['Mercredi', this.days.mercredi],
                ['Jeudi', this.days.jeudi],
                ['Vendredi', this.days.vendredi],
              ]"
            ></pie-chart>
          </v-col>
          <v-col cols="2" sm="5" md="5">
            <column-chart
              :data="[
                ['Lundi', this.days.lundi],
                ['Mardi', this.days.mardi],
                ['Mercredi', this.days.mercredi],
                ['Jeudi', this.days.jeudi],
                ['Vendredi', this.days.vendredi],
              ]"
            ></column-chart>
          </v-col>
          <v-col cols="2" sm="2" md="2">
            <column-chart
              :data="[['Total', this.total_semaine]]"
            ></column-chart>
          </v-col>
        </v-row>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import axios from "axios";
import moment from "moment";

export default {
  name: "WorkingTimes",
  data() {
    return {
      workingtimes: [],
      path: "http://localhost:4000/api/workingtimes",
      userId: 10001,
      days: {
        lundi: "00:00",
        mardi: "00:00",
        mercredi: "00:00",
        jeudi: "00:00",
        vendredi: "00:00",
      },
      day: "",
      heures_jour: "00:00",
      total_semaine: "00:00",
      startDate: "",
      endDate: "",
      date_actuelle: "",
      date_actuelle_2: "",
      starthour: "",
      endhour: "",
      rest: "00:00",
      createWorkingTimeDialog: false,
      editWorkingTimeDialog: false,
    };
  },
  mounted() {
    this.date_actuelle_now();
    this.getWorkingTimes(this.userId, this.date_actuelle);
  },

  methods: {
    getWorkingTimes(user_id, date) {
      axios
        .get(this.path + "/" + user_id)
        .then((response) => {
          this.workingtimes = response.data.data;
          this.sommer_workingtimes(this.workingtimes.length, date);
        })
        .catch((err) => console.log(err.message));
    },

    m_trouver_days(date) {
      var date_format = new Date(date);
      this.day = date_format.getDay();
    },

    sommer_workingtimes(size_objects, date) {
      this.m_trouver_days(date);
      var jour_counter = this.day;
      var co = 1;
      for (var ii = jour_counter; ii >= 0; ii--) {
        for (var i = 0; i < size_objects; i++) {
          this.startDate = this.workingtimes[i].start;
          this.endDate = this.workingtimes[i].end;
          var start_Date_format = this.startDate.substr(0, 10);
          date = this.date_actuelle;
          if (date === start_Date_format) {
            this.starthour = this.startDate.substr(11, 5);
            this.endhour = this.endDate.substr(11, 5);
            this.resterHeures(this.starthour, this.endhour);
            this.sommerHeures(this.heures_jour, this.rest);

            switch (ii) {
              case 1:
                this.days.lundi = this.heures_jour;
                break;
              case 2:
                this.days.mardi = this.heures_jour;
                break;
              case 3:
                this.days.mercredi = this.heures_jour;
                break;
              case 4:
                this.days.jeudi = this.heures_jour;
                break;
              case 5:
                this.days.vendredi = this.heures_jour;
                break;
            }
          }
        }

        this.rester_date(co);
        co++;
        this.date_convertion_nouvelle(this.date_actuelle_2);
        this.heures_jour = "00:00";
      }

      this.total_semaine =
        parseFloat(this.days.lundi) +
        parseFloat(this.days.mardi) +
        parseFloat(this.days.mercredi) +
        parseFloat(this.days.jeudi) +
        parseFloat(this.days.vendredi);
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
      this.total_semaine = heures.toString() + "." + minutes.toString();
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
      this.heures_jour = heures.toString() + "." + minutes.toString();
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

      this.rest = heures + ":" + minutes;
    },

    rester_date(monto) {
      var date2 = new Date();
      date2.setDate(date2.getDate() - monto);
      this.date_actuelle_2 = date2;
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
      this.date_actuelle = annee + "-" + mois + "-" + jour;
      //this.date_actuelle = "2021-11-10";
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
      this.date_actuelle = annee + "-" + mois + "-" + jour;
      //this.date_actuelle = "2021-11-10";
    },
    getWorkingTimesByDates(userId) {
      axios
        .get(
          this.path +
            "/" +
            userId +
            "?" +
            "start=" +
            this.startDate +
            "&end=" +
            this.endDate
        )
        .then((response) => {
          console.log(response.data);
        });
    },
    createWorkingTime(user_id, dateStart, dateEnd, path) {
      var create_path;
      if (path == "") {
        create_path = this.path;
      } else create_path = path;
      axios
        .post(create_path + "/" + user_id, {
          workingtime: {
            start: dateStart,
            end: dateEnd,
          },
        })
        .then((response) => {
          console.log(response.data);
        })
        .catch((err) => console.log(err.message));
    },
    updateWorkingTime(id) {
      axios
        .put(this.path + "/" + id, {
          workingtime: {
            start: this.newDateStart,
            end: this.newDateEnd,
          },
        })
        .then((response) => {
          console.log(response.data);
          location.reload();
        })
        .catch((err) => console.log(err.message));
    },
    deleteWorkingTime(id) {
      axios
        .delete(this.path + "/" + id)
        .then((response) => {
          console.log(response);
          location.reload();
        })
        .catch((err) => console.log(err.message));
    },
    format_date(value) {
      if (value) {
        return moment(String(value)).format("DD/MM/YYYY hh:mm");
      }
    },
    closeNewWorkingTimeDialog() {
      this.newWorkingTimeDialog = false;
      location.reload();
    },
    closeEditWorkingTimeDialog() {
      this.editWorkingTimeDialog = false;
      location.reload();
    },
  },
};
</script>

<style scoped>
div #select {
  color: #6a66d8;
  font-size: 40px;
}
</style>
