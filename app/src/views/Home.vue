<template>
  <div class="about">
    <span v-if="this.$store.getters.isLoggedIn">
        <h1>Welcome {{this.$store.state.user.name}} to upfeat.ibiscybernetics.com!</h1>
        <p>You are now logged in to this simple Hello World example.</p>
        <p>Your name is: {{this.$store.state.user.name}}</p>
        <p>Your email is: {{this.$store.state.user.email}}</p>
    </span>
    <span v-else>
        <h1>Welcome to the Cloud DevOps practice site.</h1>
        <p>
           If this is your first time, click "Register" above.
        </p>
        <p>
           If you registered successfully, you will return to the home page.
        </p>
        <p>
           Afterwards you can navigate to the "Login" page and attempt to login.
        </p>
    </span>
  </div>
</template>
