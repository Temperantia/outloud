<template>
  <Page
  class="register"
  actionBarHidden="true">
    <FlexboxLayout
    flexDirection="column"
    justifyContent="center">
      <StackLayout class="form">
        <StackLayout
        class="input-container"
        orientation="horizontal">
          <StackLayout class="text">
            <Label text="PASSWORD"></Label>
          </StackLayout>
          <TextField
          class="input"
          hint="••••••••"
          secure="true"
          v-model="password">
          </TextField>
        </StackLayout>
        <Label
        class="error"
        :text="errorPassword"></Label>
        <StackLayout
        class="input-container"
        orientation="horizontal">
          <StackLayout class="text">
            <Label text="CONFIRM PASSWORD"></Label>
          </StackLayout>
          <TextField
          class="input"
          hint="••••••••"
          secure="true"
          v-model="confirmPassword">
          </TextField>
        </StackLayout>
        <Label
        class="error"
        :text="errorConfirmPassword"></Label>
        <Button
        class="btn btn-register"
        text="GET ME IN"
        @tap="onRegisterTap" />
      </StackLayout>
    </FlexboxLayout>
  </Page>
</template>

<script lang="ts">
import App from '../App.vue';
export default {
  data: () => ({
    confirmPassword: '',
    errorConfirmPassword: '',
    errorPassword: '',
    password: '',
  }),
  methods: {
    onRegisterTap() {
      this.errorPassword = '';
      if (this.password.length < 8) {
        this.errorPassword = 'Password has to contain at least 8 characters';
      } else if (this.confirmPassword !== this.password) {
        this.errorConfirmPassword = 'Passwords must match';
      } else {
        // API call and maybe add info to state from response
        this.$navigateTo(App);
      }
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~/_app-variables';

.register {
  background-image: url('~/assets/images/2.jpg');
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;

  .form {
    .input-container {
      height: 50vw;
      margin: 0 50px 10px 50px;

      .text {
        width: 25%;
        height: 100%;
        color: $white;
        background-color: $primary;
        font-family: 'Roboto-Bold';
        border-top-left-radius: 5px;
        border-bottom-left-radius: 5px;
        text-align: center;
        vertical-align: center;
      }

      .input {
        width: 75%;
        height: 100%;
        color: $black;
        background-color: $white;
        border: 1px solid $primary;
        border-top-right-radius: 5px;
        border-bottom-right-radius: 5px;
      }
    }

    .error {
      color: $secondary;
      margin-left: 50px;
    }

    .btn-register {
      width: 50%;
      height: 50vw;
    }
  }
}
</style>
