import { createApp } from "vue";
import "./style.css";
import App from "./App.vue";
import router from "@/router";
// 引入饿了么plus
import ElementPlus from "element-plus";
import "element-plus/dist/index.css";
// 引入icon图标
import "@/assets/icon/iconfont.css";
// 引入Cookies
import VueCookies from "vue-cookies";
// 引入vuex
import store from "@/store";

import message from "./utils/Message";
import request from "@/utils/request";
import confirm from "@/utils/Confirm";
import verify from "@/utils/Verify";
// 封装的组件
import Table from "@/components/Table.vue";
import Cover from "@/components/Cover.vue";
import Dialog from "@/components/Dialog.vue";
import CoverUpload from "@/components/CoverUpload.vue";
import Window from "@/components/Window.vue";
import EditorMarkdown from "@/components/EditorMarkdown.vue";
import EditorHtml from "@/components/EditorHtml.vue";

const app = createApp(App);
// vue3不再是new Vue({router, render: h => h(App)}).$mount('#app')
app.use(router);
app.use(ElementPlus);
app.use(store);
// 注册全局属性
app.config.globalProperties.VueCookies = VueCookies;
app.config.globalProperties.Request = request;
app.config.globalProperties.Message = message;
app.config.globalProperties.Confirm = confirm;
app.config.globalProperties.Verify = verify;
app.config.globalProperties.globalInfo = {
  imageUrl: "/api/file/getImage/",
};
// 注册全局组件
app.component("Table", Table);
app.component("Cover", Cover);
app.component("Dialog", Dialog);
app.component("CoverUpload", CoverUpload);
app.component("Window", Window);
app.component("EditorMarkdown", EditorMarkdown);
app.component("EditorHtml", EditorHtml);
app.mount("#app");
