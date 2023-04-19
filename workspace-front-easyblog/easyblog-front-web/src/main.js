import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
// 引入饿了么plus
import ElementPlus from "element-plus";
import "element-plus/dist/index.css";

import request from "@/utils/request";

// 封装的组件
import Cover from "@/components/Cover.vue";
import BlogItem from "@/components/BlogItem.vue";
import RightCategory from "@/components/RightCategory.vue";
import RightUser from "@/components/RightUser.vue";
import UserItem from "@/components/UserItem.vue";

import "@/assets/base.scss";
import "@/assets/global.css";
const app = createApp(App);

app.use(router);
app.use(ElementPlus);
// 注册全局属性
// app.config.globalProperties.VueCookies = VueCookies;
app.config.globalProperties.Request = request;
app.config.globalProperties.globalInfo = {
  imageUrl: "/api/file/getImage/",
};
// 注册全局组件
app.component("Cover", Cover);
app.component("BlogItem", BlogItem);
app.component("RightCategory", RightCategory);
app.component("RightUser", RightUser);
app.component("UserItem", UserItem);
app.mount("#app");
