<template>
  <div class="container">
    <div class="main" v-for="item in categoryList" :key="item">
      <img :src="proxy.globalInfo.imageUrl + item.cover" alt="" />
      <div class="content">
        <router-link
          class="categoryName"
          :to="'/category/' + item.categoryId"
          >{{ item.categoryName }}</router-link
        >
        <div class="categoryDesc" :title="item.categoryDesc">
          {{ item.categoryDesc }}
        </div>
        <p class="blogCount">文章数：{{ item.blogCount }}</p>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, getCurrentInstance } from "vue";
const { proxy } = getCurrentInstance();
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
getCategoryList();
</script>

<style lang="scss" scoped>
.container {
  background-color: #fff;
  display: flex;
  flex-wrap: wrap;
  padding: 10px;
  .main {
    width: 265px;
    height: 100px;
    margin: 10px 8px;
    padding: 10px;
    border: 1px solid #c1ccd7;
    border-radius: 5px;
    display: flex;
    img {
      width: 80px;
      height: 80px;
      border-radius: 4px;
      margin-right: 10px;
    }
    .content {
      .categoryName {
        font-size: 16px;
      }
      .categoryDesc {
        margin: 5px 0;
        font-size: 12px;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 1;
        line-clamp: 1;
        -webkit-box-orient: vertical;
      }
      .blogCount {
        font-size: 10px;
        color: #7f8790;
      }
    }
  }
}
</style>
