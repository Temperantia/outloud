<template>
  <Page
  class="register"
  actionBarHidden="true">
    <FlexboxLayout
    flexDirection="column"
    justifyContent="center">
      <StackLayout class="form">
        <StackLayout
        class="date-container"
        orientation="horizontal">
          <StackLayout class="text">
            <Label text="BIRTH"></Label>
          </StackLayout>
          <DatePicker
          class="input"
          :maxDate="maxDate"
          v-model="birthDate" />
        </StackLayout>
        <Label
        class="error"
        :text="errorBirth"></Label>
        <Button
        class="btn btn-register"
        text="NEXT"
        @tap="onNextTap" />
      </StackLayout>
    </FlexboxLayout>
  </Page>
</template>

<script lang="ts">
import Register3 from './Register3.vue';
export default {
  data: () => ({
    birthDate: '',
    errorBirth: '',
    confirmPassword: '',
    maxDate: new Date(),
    password: '',
  }),
  methods: {
    onNextTap() {
      const birthDate: Date = new Date(this.birthDate);
      const today: Date = new Date();
      let age: number = today.getFullYear() - birthDate.getFullYear();
      const m: number = today.getMonth() - birthDate.getMonth();
      if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
          age = age - 1;
      }
      if (age < 16) {
        this.errorBirth = 'You need to be 16+ to join Inc•lusive'
      } else {
        this.$store.dispatch('userRegister2', {birthDate});
        this.$navigateTo(Register3);
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
    }

    .date-container {
      height: 100vw;
      margin: 0 50px 10px 50px;

      .text {
        width: 25%;
        height: 100%;
        color: $white;
        background-color: $primary;
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
