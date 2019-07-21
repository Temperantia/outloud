<template>
  <Page
  class="register"
  actionBarHidden="true">
    <FlexboxLayout
    flexDirection="column"
    justifyContent="center">
    <StackLayout
    orientation="horizontal">

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
    errorRegister: '',
    password: '',
  }),
  methods: {
    async onRegisterTap() {
      this.errorPassword = '';
      this.errorConfirmPassword = '';
      this.errorRegister = '';
      if (this.password.length < 8) {
        this.errorPassword = 'Password has to contain at least 8 characters';
      } else if (this.confirmPassword !== this.password) {
        this.errorConfirmPassword = 'Passwords must match';
      } else {
        try {
          const user = this.$store.state.user;
          const response = await this.$http.post(
            `${process.env.URL_API}/user`, {
              birthDate: user.birthDate,
              email: user.email,
              name: user.name,
              password: this.password,
            }
          );
          this.$http.defaults.headers.common.Authorization = response.data.token;
          this.$navigateTo(App);
        } catch (error) {
          console.error(error);
          this.errorRegister = 'Something turned wrong. Please try again later.'
        }
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
