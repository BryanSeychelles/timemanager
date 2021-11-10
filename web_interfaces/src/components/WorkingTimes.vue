<template>
  <div>
    <v-container>
      <h2 class="text-center mb-4">Statistiques</h2>
      <v-row justify="center" class="align-center">
        <!-- MODAL NEW WORKINGTIME -->
        <v-dialog v-model="createWorkingTimeDialog" class="mr-4" persistent max-width="600px">
          <template v-slot:activator="{ on, attrs }">
            <v-btn color="primary" dark v-bind="attrs" v-on="on"
              >New Workingtime</v-btn
            >
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
              <v-spacer></v-spacer>
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
                    ""
                  )
                "
                >Save</v-btn
              >
            </v-card-actions>
          </v-card>
        </v-dialog>

        <column-chart :data="[['Mar', 32], ['Mon', 46], ['Tue', 28]]"></column-chart>
        <pie-chart :data="[['Blueberry', 44], ['Strawberry', 23]]"></pie-chart>
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
      userId: 1,
      newDateStart: "",
      newDateEnd: "",
      createWorkingTimeDialog: false,
      editWorkingTimeDialog: false,
    };
  },
  mounted() {
    this.getWorkingTimes(this.$route.params.user_id);
  },
  methods: {
    getWorkingTimes(user_id) {
      axios
        .get(this.path + "/" + this.userId)
        .then((response) => {
          console.log(response.data.data);
          this.workingtimes = response.data.data;
        })
        .catch((err) => console.log(err.message));
    },
    getWorkingTimesByDates(user_id) {
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
