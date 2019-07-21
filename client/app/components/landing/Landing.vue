<template>
  <Page
  actionBarHidden="true">

    <FlexboxLayout
    class="container"
    flexDirection="column"
    justifyContent="space-between">
      <StackLayout>
        <StackLayout class="logo-container">
          <Image class="logo" src="~/assets/images/logo.png" stretch="aspectFit" />
          <Label
          class="motto"
          text="Let's include today !">
          </Label>
        </StackLayout>
      </StackLayout>
      <StackLayout class="buttons">
        <Button
        class="btn btn-landing"
        text="Log Me In"
        @tap="onLoginTap"/>
        <Button
        class="btn btn-landing"
        text="Get Me In"
        @tap="onRegisterTap"/>
      </StackLayout>
    </FlexboxLayout>

  </Page>
</template>

<script lang="ts">
import Login from './Login.vue';
import Register1 from './Register1.vue';
export default {
  methods: {
    onLoginTap() {
      this.$navigateTo(Login);
    },
    onRegisterTap() {
      this.$navigateTo(Register1);
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~/_app-variables';

  .logo-container {
    width: 50%;
    border-radius: 5px;

    .logo {
    }

    .motto {
      color: $primary;
      margin: 10px;
      text-align: center;
    }
  }

  .buttons {
    vertical-align: center;
  }

  .btn-landing {
    width: 50%;
    height: 50vw;
    margin: 50px 0;
  }
.background {
}
.container {
  background: linear-gradient(135deg, rgba(253, 97, 0, 0.3) 0%,rgba(0, 87, 146, 0.3) 99%);

}
</style>
