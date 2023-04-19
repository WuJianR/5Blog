<template>
  <div>
    <div class="top">
      <div class="top-nav">
        <router-link to="/" class="logo">5-Blog</router-link>
        <router-link
          v-for="item in menus"
          :key="item"
          :class="['nav', item.path == activePath ? 'active' : '']"
          :to="item.path"
          >{{ item.name }}</router-link
        >
      </div>
    </div>
    <div class="body-container">
      <div class="body-main">
        <router-view></router-view>
      </div>
    </div>
    <div class="footer">
      <div>
        @2022-{{ new Date().getFullYear() }} www.5blog.com rights reserved.{{
          sysInfo.policeProvince
        }}ICP备{{ sysInfo.icpNo }}
      </div>
      <div>{{ sysInfo.policeProvince }}公网安备{{ sysInfo.policeNo }}</div>
    </div>
  </div>
</template>

<script setup>
import { ref, getCurrentInstance, watch } from "vue";
import { useRouter } from "vue-router";
const { proxy } = getCurrentInstance();
const router = useRouter();
const api = {
  getSysInfo: "/view/getSysInfo", // 页面初始化获取 备案信息，是否开启评价
};
const sysInfo = ref({});
const loadSysInfo = async () => {
  let result = await proxy.Request({
    url: api.getSysInfo,
  });

  if (!result) {
    return;
  }
  sysInfo.value = result.data;
};
const init = () => {
  loadSysInfo();
};
init();
const currentPath = ref("/");
const menus = ref([
  {
    name: "博客",
    path: "/",
  },
  {
    name: "分类专栏",
    path: "/category",
  },
  {
    name: "专题",
    path: "/special",
  },
  {
    name: "成员",
    path: "/user",
  },
  {
    name: "留言",
    path: "/comment",
  },
]);
const activePath = ref(null);
watch(
  () => router,
  (newVal, oldVal) => {
    activePath.value = newVal.currentRoute.value.meta.activePath;
  },
  { immediate: true, deep: true }
);
</script>

<style lang="scss" scoped></style>
