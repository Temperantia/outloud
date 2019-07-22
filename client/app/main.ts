import Vue from 'nativescript-vue';
import Vuelidate from 'vuelidate';
import axios from 'axios';
import VueAxios from 'vue-axios';

import Landing from './components/landing/Landing.vue';
import store from './store';

// Prints Vue logs when --env.production is *NOT* set while building
Vue.config.silent = (TNS_ENV === 'production');

Vue.use(Vuelidate);
Vue.use(VueAxios, axios);

new Vue({
  render: (h) => h('frame', [h(Landing)]),
  store,
}).$start();
