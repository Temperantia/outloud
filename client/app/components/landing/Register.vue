<template>
  <Page
  class="register"
  actionBarHidden="true">
    <FlexboxLayout flexDirection="column">
    <Image width="30%" src="~/assets/images/logo_transparent.png" stretch="aspectFit" />
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
        hint="jo•hn•ane.doe@gmail.com"
        keyboardType="email"
        v-model="email">
        </TextField>
      </StackLayout>
      <StackLayout
      class="date-container"
      orientation="horizontal">
        <StackLayout class="text">
          <Label text="BIRTH"></Label>
        </StackLayout>
        <DatePicker
        class="input"
        v-model="birth" />
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
      <Button
      class="btn btn-register"
      text="GET ME IN"
      @tap="onRegisterTap" />
    </StackLayout>
    </FlexboxLayout>
  </Page>
</template>

<script lang="ts">
export default {
  data: () => ({
    birth: '',
    confirmPassword: '',
    email: '',
    name: '',
    password: '',
  }),
  methods: {
    onRegisterTap() {
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~/_app-variables';

.register {
  &::before {
    background-image: url('~/assets/images/2.jpg');
    background-repeat: no-repeat;
    background-position: center;
    background-size: cover;
    opacity: 0.5;
  }

  .logo {
  }

  .form {
    vertical-align: center;

    .input-container {
      height: 6%;
    }

    .date-container {
      height: 13%;
    }

    .input-container,
    .date-container {
      margin: 50px;

      .text {
        width: 25%;
        height: 100%;
        color: $white;
        background-color: $orange;
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
        border: 1px solid $orange;
        border-top-right-radius: 5px;
        border-bottom-right-radius: 5px;
      }
    }

    .btn-register {
      width: 50%;
      height: 10%;
      margin: 20px;
    }
  }
}

</style>
