import { createStore } from "vuex";

const store = createStore({
  state: {
    userInfo: {
      nickName: "",
      avatar: "",
    },
  },
  mutations: {
    updateUserInfo(state, userInfo) {
      state.userInfo = userInfo;
    },
  },
});

export default store;
