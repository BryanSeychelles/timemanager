<template>
  <div>
    <div>
      <v-btn
        class="ma-4"
        :color="btn_color"
        dark
        elevation="2"
        x-large
        v-on:click="switchClock()"
        >{{ btn_text }}</v-btn
      >
    </div>
  </div>
</template>

<script>
import axios from "axios";
import moment from "moment";

//moment(this.clock.time, "“YYYY-MM-DD hh:mm:ss").fromNow();

export default {
  name: "Clockmanager",
  data() {
    return {
      path: "http://" + process.env.VUE_APP_SERVICE_URL + ":4000/api/clocks",
      token: localStorage.getItem("user_token"),
      current_user_id: localStorage.getItem("user_id"),
      clock: [],
      btn_text: "Start",
      btn_color: "green",
    };
  },
  async mounted() {
    await this.getClock(this.current_user_id);
    if (this.clock == null) {
      await this.createClock(this.current_user_id, this.getDate(), false);
    }
    if (this.clock.status == true) {
      this.btn_text = "End";
      this.btn_color = "red";
    }
  },
  methods: {
    async getClock(UserID) {
      const response = await axios
        .get(this.path + "/" + UserID, {
          headers: { Authorization: `Bearer ${this.token}` },
        })
        .catch((err) => console.log(err.message));
      if (response != null) {
        this.clock = response.data.data;
      }
      //console.log(response.data.data);
    },
    async createClock(UserID, clock_time, Status) {
      const response = await axios
        .post(
          this.path + "/" + UserID,
          {
            clock: {
              time: clock_time,
              status: Status,
              user_id: UserID,
            },
          },
          {
            headers: { Authorization: `Bearer ${this.token}` },
          }
        )
        .catch((err) => console.log(err.message));
      await this.getClock(this.current_user_id);
    },
    async updateClock(UserID, clock_time, Status) {
      const response = await axios
        .put(
          this.path + "/" + UserID,
          {
            clock: {
              time: clock_time,
              status: Status,
            },
          },
          {
            headers: { Authorization: `Bearer ${this.token}` },
          }
        )
        .catch((err) => console.log(err.message));
      await this.getClock(this.current_user_id);
    },
    async manageClock(UserID, clock_time) {
      if (!this.clock.status == false) {
        this.createWorkingTime(
          this.clock.user_id,
          this.clock.time,
          this.getDate(),
          "http://" + process.env.VUE_APP_SERVICE_URL + ":4000/api/workingtimes"
        );
      }
      await this.updateClock(
        this.clock.user_id,
        clock_time,
        !this.clock.status
      );
    },
    createWorkingTime(user_id, dateStart, dateEnd, path) {
      axios
        .post(
          path + "/" + user_id,
          {
            workingtime: {
              start: dateStart,
              end: dateEnd,
            },
          },
          {
            headers: { Authorization: `Bearer ${this.token}` },
          }
        )
        .then((response) => {
          console.log(response.data);
        })
        .catch((err) => console.log(err.message));
    },

    async switchClock() {
      await this.getClock(this.current_user_id);
      console.log(this.clock);
      if (!this.clock.status) {
        //if clock is running
        this.btn_text = "End";
        this.btn_color = "red";
        this.manageClock(this.current_user_id, this.clock.time);
      } else {
        //if clock is not running
        this.btn_text = "Start";
        this.btn_color = "green";
        this.manageClock(this.current_user_id, this.getDate());
      }
      console.log("switch");
      console.log(this.clock.status);
    },

    getDate() {
      var date = new Date().toISOString();
      date = date.replace("T", " ").replace("Z", "").replace(/\.[0-9]{0,10}/, "");
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
