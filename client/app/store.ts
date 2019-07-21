import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    user: {
      birth: '',
      email: '',
      name: '',
    },
  },
  mutations: {
    userChangeBirth(state, birth) {
      state.user.birth = birth;
    },
    userChangeEmail(state, email) {
      state.user.email = email;
    },
    userChangeName(state, name) {
      state.user.name = name;
    },
  },
  actions: {
    userRegister1(context, user) {
      context.commit('userChangeName', user.name);
      context.commit('userChangeEmail', user.email);
    },
    userRegister2(context, user) {
      context.commit('userChangeBirth', user.birth);
    },
  }
});
