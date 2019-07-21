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
            <Label text="NAME"></Label>
          </StackLayout>
          <TextField
          class="input"
          hint="Jo•hn•ane Doe"
          v-model="name">
          </TextField>
        </StackLayout>
        <StackLayout
        class="input-container"
        orientation="horizontal">
          <StackLayout class="text">
            <Label text="EMAIL"></Label>
          </StackLayout>
          <TextField
          class="input"
          hint="someone@gmail.com"
          keyboardType="email"
          v-model="email">
          </TextField>
        </StackLayout>
        <Label
        class="error"
        :text="errorEmail"></Label>
        <Button
        class="btn btn-register"
        text="NEXT"
        @tap="onNextTap" />
      </StackLayout>
    </FlexboxLayout>
  </Page>
</template>

<script lang="ts">
import Register2 from './Register2.vue';
export default {
  data: () => ({
    email: '',
    emailRegex: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
    errorEmail: '',
    name: '',
  }),
  methods: {
    onNextTap() { // TODO check name is not empty
    // TODO display steps
      if (!this.emailRegex.test(this.email.toString().toLowerCase())) {
        this.errorEmail = 'Please enter a valid email';
      } else {
        this.$store.dispatch('userRegister1', {name: this.name, email: this.email});
        this.$navigateTo(Register2);
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
