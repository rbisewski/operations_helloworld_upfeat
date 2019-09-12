<template>
  <div>
    <h1>Register</h1>
    <form @submit.prevent="register">
      <label for="name">Name</label>
      <div>
          <input id="name" type="text" v-model="name" required autofocus>
      </div>

      <label for="email" >E-Mail Address</label>
      <div>
          <input id="email" type="email" v-model="email" required>
      </div>

      <label for="password">Password</label>
      <div>
          <input id="password" type="password" v-model="password" required>
      </div>

      <label for="password-confirm">Confirm Password</label>
      <div>
          <input id="password-confirm" type="password" v-model="password_confirmation" required>
      </div>

      <div>
          <button type="submit">Register</button>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      name: "",
      email: "",
      password: "",
      password_confirmation: "",
    };
  },

  methods: {
    register: function() {
      let data = {
        name: this.name,
        email: this.email,
        password: this.password,
      };
      let registrationSuccessful = true;

      if (this.password.length < 8) {
            this.$notify({
                group: 'messages',
                type: 'error',
                title: 'Error',
                text: 'Password should be at least 8 characters.'
                });
            return;
      }

      if (this.password !== this.password_confirmation) {
            this.$notify({
                group: 'messages',
                type: 'error',
                title: 'Error',
                text: 'Passwords do not match.'
                });
            return;
      }

      this.$store
        .dispatch("register", data)
        .then(() => this.$router.push("/"))
        .catch(err =>
            this.$notify({
                group: 'messages',
                type: 'error',
                title: 'Error',
                text: err
            }), registrationSuccessful = false
        );

      if (registrationSuccessful === true) {
            this.$notify({
                group: 'messages',
                type: 'important',
                title: 'Success',
                text: 'You have successfully registered. Now go ahead and click "Login" to login to your account.',
                duration: 6000
            });
      }
    }
  }
};
</script>
