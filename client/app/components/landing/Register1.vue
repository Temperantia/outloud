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
import { email, required } from 'vuelidate/lib/validators';

import Register2 from './Register2.vue';

export default {
  computed: {
    errorEmail: function() {
      if (this.$v.email.pending) {
        return '';
      }
      if (!this.$v.email.email) {
        return 'Please enter a valid email';
      } else if (!this.$v.email.isUnique) {
        return 'Email is already used';
      }
      return '';
    },
  },
  data: () => ({
    email: '',
    name: '',
  }),
  methods: {
    onNextTap() {
    // TODO display steps
    this.$v.$touch();
    if (!this.$v.$invalid) {
        this.$store.dispatch('userRegister1', {
          name: this.name,
          email: this.email,
        });
        this.$navigateTo(Register2);
      }
    },
  },
  validations: {
    email: {
      email,
      async isUnique(value) {
        if (value === '') {
          return true;
        }

        const response = await this.$http.get(
          `${process.env.URL_API}/user/exist/email/${value}`
        );
        return !response.data.exist;
      },
    },
    username: {
      async isUnique(value) {
        if (value === '') {
          return true;
        }

        const response = await this.$http.get(
          `${process.env.URL_API}/user/exist/username/${value}`
        );
        return !response.data.exist;
      },
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
