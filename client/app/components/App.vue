<template>
 <Page
  class="app"
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
          hint="someone@gmail.com"
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
        <Label
        class="error"
        :text="errorLogin"></Label>
      </StackLayout>
    </FlexboxLayout>
  </Page>
</template>

<script lang="ts">
  export default {
    data() {
      return {
        msg: 'Hello World'
      }
    }
  }
</script>

<style lang="scss" scoped>
  ActionBar {
    background-color: #53ba82;
    color: #ffffff;
  }

  .message {
    vertical-align: center;
    text-align: center;
    font-size: 20;
    color: #333333;
  }
</style>
