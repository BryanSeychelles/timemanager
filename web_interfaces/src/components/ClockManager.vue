<template>
  <div>
    <v-switch v-model="switchMe" v-on:click="manageClock(userID, startDateTime, true)">
      <template v-slot:label>
        Turn on the progress: <v-progress-circular
          :indeterminate="switchMe"
          :value="0"
          size="24"
          class="ml-2"
        ></v-progress-circular>
      </template>
    </v-switch>
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
      path: "http://localhost:4000/api/clocks",
      startDateTime: this.getDate(),
      userID: 1, // current_user in future
      clock: null,
      switchMe: false
    };
  },
  mounted() {
    this.getClock(userId)
  },
  methods: {
    async getClock(UserID) {
      const response = await axios
        .get(this.path + "/" + UserID)
        .catch((error) => console.log(error));
      this.clock = response.data.data;
      console.log(this.clock)
    },
    createClock(UserID, startTime, Status) {
      axios
        .post(this.path + "/" + UserID, {
          clock: {
            time: startTime,
            status: Status,
            user_id: UserID,
          },
        })
        .then((response) => {})
        .catch((err) => console.log(err.message));
    },
    updateClock(UserID, startTime, Status) {
      axios
        .put(this.path + "/" + UserID, {
          clock: {
            time: startTime,
            status: Status
          },
        })
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
            "http://localhost:4000/api/workingtimes"
          );
        } else {
          clock_start_time = this.getDate();
        }
        this.updateClock(this.clock.user_id, clock_start_time, !this.clock.status);
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
