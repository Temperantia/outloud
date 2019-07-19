<template>
  <Page
  class="login"
  actionBarHidden="true">
    <FlexboxLayout
    flexDirection="column"
    justifyContent="center">
      <StackLayout class="form">
        <StackLayout
        class="input-container"
        orientation="horizontal">
          <StackLayout class="text">
            <Label text="EMAIL"></Label>
          </StackLayout>
          <TextField
          class="input"
          hint="jo•hn•ane.doe@gmail.com"
          keyboardType="email"
          v-model="email">
          </TextField>
        </StackLayout>
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
        <Button
        class="btn btn-login"
        text="LOG ME IN"
        @tap="onLoginTap" />
      </StackLayout>
    </FlexboxLayout>
  </Page>
</template>

<script lang="ts">
export default {
  data: () => ({
    email: '',
    password: '',
  }),
  methods: {
    onLoginTap() {

    },
  },
};
</script>

<style lang="scss" scoped>
@import '~/_app-variables';

.login {
  background-image: url('~/assets/images/2.jpg');
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;

  .form {
    .input-container {
      height: 50vw;
    }

    .input-container {
      margin: 0 50px 50px 50px;

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

    .btn-login {
      width: 50%;
      height: 50vw;
      margin-top: 50px;
    }
  }
}
</style>
