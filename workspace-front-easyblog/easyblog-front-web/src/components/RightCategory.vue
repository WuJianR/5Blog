<template>
  <!-- 分类 -->
  <div>
    <div class="cateTitle">
      <span>分类专栏</span>
      <router-link to="/category" class="router-link">更多>></router-link>
    </div>
    <div
      class="cateContent"
      v-for="item in categoryList"
      :key="item.categoryId"
    >
      <div class="coverTitle">
        <Cover :cover="item.cover" :width="40"></Cover>
        <router-link
          :to="'/category/' + item.categoryId"
          :key="route.fullPath"
          >{{ item.categoryName }}</router-link
        >
      </div>
      <div class="contentNum">{{ item.blogCount }}篇</div>
    </div>
  </div>
</template>

<script setup>
import { ref, getCurrentInstance, watch } from "vue";
import { useRoute } from "vue-router";
const { proxy } = getCurrentInstance();
const route = useRoute();
// api
const api = {
  loadCategoryList: "/view/loadCategory", // 获取分类列表
};
// 获取分类列表
const categoryList = ref({});
const getCategoryList = async () => {
  let result = await proxy.Request({
    url: api.loadCategoryList,
  });
  if (!result) {
    return;
  }
  categoryList.value = result.data;
};

const init = () => {
  getCategoryList();
};
init();
watch(
  () => route.params.categoryId,
  (newVal, oldVal) => {
    location.reload();
  },
  { immediate: false, deep: true }
);
</script>

<style lang="scss" scoped>
.cateTitle {
  display: flex;
  padding: 10px;
  justify-content: space-between;
  border-bottom: 1px solid #7f8790;
  font-size: 14px;
  .router-link {
    font-size: 8px;
  }
}
.cateContent {
  display: flex;
  justify-content: space-between;
  height: 40px;
  margin: 15px;
  line-height: 40px;
  .coverTitle {
    display: flex;
    font-size: 14px;
    a {
      margin-left: 10px;
    }
  }
  .contentNum {
    font-size: 6px;
    color: #7f8790;
  }
}
</style>
