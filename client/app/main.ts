import Vue from 'nativescript-vue';
import Landing from './components/landing/Landing.vue';
import store from './store';

// Prints Vue logs when --env.production is *NOT* set while building
Vue.config.silent = (TNS_ENV === 'production');

new Vue({
  render: (h) => h('frame', [h(Landing)]),
  store,
}).$start();
