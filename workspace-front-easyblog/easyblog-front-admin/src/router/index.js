// vue3不再是import VueRouter from 'vue-router'
import { createRouter, createWebHistory } from "vue-router";
import VueCookies from "vue-cookies";

const routes = [
  {
    path: "/",
    name: "main",
    redirect: "/home",
  },
  {
    name: "登录页",
    path: "/login",
    component: () => import("../views/Login.vue"),
  },
  {
    name: "框架页",
    path: "/home",
    redirect: "blog/list",
    component: () => import("../views/Framework.vue"),
    children: [
      {
        name: "博客管理",
        path: "/blog/list",
        component: () => import("../views/Blog/BlogList.vue"),
      },
      {
        name: "分类管理",
        path: "/blog/category",
        component: () => import("../views/Blog/BlogCategory.vue"),
      },
      {
        name: "专题管理",
        path: "/special/list",
        component: () => import("../views/special/SpecialList.vue"),
      },
      {
        name: "个人信息设置",
        path: "/settings/my",
        component: () => import("../views/settings/MyInfo.vue"),
      },
      {
        name: "博客成员",
        path: "/settings/user",
        component: () => import("../views/settings/TeamUser.vue"),
      },
      {
        name: "系统设置",
        path: "/settings/sysInfo",
        component: () => import("../views/settings/SysInfo.vue"),
      },
      {
        name: "回收站",
        path: "/recovery/list",
        component: () => import("../views/recovery/RecoveryList.vue"),
      },
    ],
  },
];

// vue3不是通过new来创建，通过createRouter方法创建，使用的模式不是通过mode来定义
const router = createRouter({
  routes,
  history: createWebHistory(),
});

// 挂载路由导航
router.beforeEach((to, from, next) => {
  // 如果是登录页直接放行
  if (to.path === "/login") {
    return next();
  }
  const cookiesUserInfo = VueCookies.get("userInfo");
  if (!cookiesUserInfo && to.path !== "/login") {
    return next("/login");
  }
  next();
});

export default router;
