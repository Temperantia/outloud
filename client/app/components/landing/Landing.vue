<template>
  <Page actionBarHidden="true">
    <FlexboxLayout flexDirection="column">
      <Image src="~/assets/images/logo_transparent.png" stretch="none"/>
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
import Register from './Register.vue';
export default {
  methods: {
    onLoginTap() {
      this.$navigateTo(Login);
    },
    onRegisterTap() {
      this.$navigateTo(Register);
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~/_app-variables';

.buttons {
  vertical-align: center;
}

.btn-landing {
  width: 50%;
  height: 20%;
  padding: 5px;
  margin: 20px;
}
</style>
