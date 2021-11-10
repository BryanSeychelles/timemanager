<template>
  <div>
    test
    <button v-on:click="getUser()">getUser</button>
    <button v-on:click="createUser(this.user)">createUser</button>
    <button
      v-on:click="updateUser(this.userID, this.user.email, this.user.username)"
    >
      updateUser
    </button>
    <button v-on:click="deleteUser(this.userID)">deleteUser</button>
  </div>
</template>

<script>
    import axios from "axios";
    export default {
    data: function () {
        return {
        path: "http://localhost:4000/api/users",
        user: { email: "test@gmail.com", username: "test" },
        userID: 1,
        };
    },
    methods: {
        getUser: function () {
        axios
            .get(
            this.path +
                "?email=" +
                this.user.email +
                "&username=" +
                this.user.username
            )
            .then((response) => {
            console.log(response.data);
            });
        },
        createUser: function (User) {
        axios
            .post(this.path, {
                user: User
            })
            .then((response) => {
            console.log(response.data);
            });
        },
        updateUser: function (UserID, Email, Username) {
        axios
            .put(this.path + "/" + UserID, {
            user: {
                email: Email,
                username: Username,
            },
            })
            .then((response) => {
            console.log(response.data);
            });
        },
        deleteUser: function (UserID) {
        axios
            .delete(this.path + "/" + UserID)
            .then((response) => {
            console.log(response);
            });
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