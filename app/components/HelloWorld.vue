<template>
    <Page class="page">
        <ActionBar title="Home" class="action-bar" />
        <ScrollView>
            <StackLayout class="home-panel">
                <Button text="Log Me In" @tap="onLogButtonTap" class="buttonLandingPage"/>
                <Button text="Get Me In" @tap="OnGetButtonTap" class="buttonLandingPage"/>
            </StackLayout>
        </ScrollView>
    </Page>
</template>
<script>
export default {
    methods: {
        OnGetButtonTap() {
            alert('Hello !!');
        },
        onLogButtonTap() {
            alert('Loggin');
        }
    },

    data () {
        return {
        };
    },
}
</script>

<style scoped>

.page {
    background-color: #f9f5f5;
}
.home-panel {
    vertical-align: center;
    font-size: 20;
    margin: 15;
}

.description-label {
    margin-bottom: 15;
}

.buttonLandingPage {
    font-size: 12;
    background-color: #ff8d00;
    color: white;
    width: 40%;
    height: 10%;
    margin: 10;

}
</style>
