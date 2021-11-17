<template>
  <div>
    <div v-if="this.clock === [] || this.clock.status === false">
      <v-btn class="ma-4" color="green" dark elevation="2" x-large v-on:click="manageClock(current_user_id, startDateTime, true), switchMe == true">Start</v-btn>
    </div>
    <div v-if="this.clock.status === true">
      <v-btn class="ma-4" color="red" dark elevation="2" x-large v-on:click="manageClock(current_user_id, startDateTime, true)">End</v-btn>
      <v-progress-circular
          :indeterminate="switchMe"
          :value="0"
          size="24"
          class="ml-2"
        ></v-progress-circular>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import moment from "moment";
import WorkingTimes from "./WorkingTimes.vue";

//moment(this.clock.time, "“YYYY-MM-DD hh:mm:ss").fromNow();

export default {
  name: "Clockmanager",
  data() {
    return {
      path: "http://" + process.env.VUE_APP_SERVICE_URL + ":4000/api/clocks",
      startDateTime: this.getDate(),
      current_user_id: localStorage.getItem("user_id"),
      clock: [],
      switchMe: false,
    };
  },
  mounted() {
    this.getClock(this.current_user_id);
  },
  methods: {
    async getClock(UserID) {
      const response = await axios
        .get(this.path + "/" + UserID, {
          headers: { Authorization: `Bearer ${this.token}` },
        })
        .catch((error) => console.log(error));
      this.clock = response.data.data;
      console.log(this.clock);
    },
    createClock(UserID, startTime, Status) {
      axios
        .post(
          this.path + "/" + UserID,
          {
            clock: {
              time: startTime,
              status: Status,
              user_id: UserID,
            },
          },
          {
            headers: { Authorization: `Bearer ${this.token}` },
          }
        )
        .then((response) => {})
        .catch((err) => console.log(err.message));
    },
    updateClock(UserID, startTime, Status) {
      axios
        .put(
          this.path + "/" + UserID,
          {
            clock: {
              time: startTime,
              status: Status,
            },
          },
          {
            headers: { Authorization: `Bearer ${this.token}` },
          }
        )
        .then((response) => {})
        .catch((err) => console.log(err.message));
    },
    async manageClock(UserID, startTime, Status) {
      await this.getClock(UserID);
      if (this.clock == null) {
        this.createClock(UserID, startTime, Status);
      } else {
        var clock_start_time = this.clock.time;
        if (!this.clock.status == false) {
          WorkingTimes.methods.createWorkingTime(
            this.clock.user_id,
            this.clock.time,
            this.getDate(),
            "http://" + process.env.VUE_APP_SERVICE_URL + ":4000/api/workingtimes"
          );
        } else {
          clock_start_time = this.getDate();
        }
        this.updateClock(
          this.clock.user_id,
          clock_start_time,
          !this.clock.status
        );
      }
    },
    getDate() {
      var date = new Date().toISOString();
      date = date.replace("T", " ");
      date = date.replace("Z", "");
      date = date.replace(/\.[0-9]{0,10}/, "");
      return date;
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
