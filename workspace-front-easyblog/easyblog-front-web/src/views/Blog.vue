<template>
  <div class="container">
    <div class="body-left">
      <blog-item
        v-for="item in blogListInfo.list"
        :key="item"
        :cover="item.cover"
        :title="item.title"
        :summary="item.summary"
        :createTime="item.createTime"
        :nickName="item.nickName"
        :categoryName="item.categoryName"
        :blogId="item.blogId"
        :categoryId="item.categoryId"
        :userId="item.userId"
      ></blog-item>
      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-if="blogListInfo.pageTotal"
          background
          :total="blogListInfo.totalCount"
          :page-size="blogListInfo.pageSize"
          v-model:current-page="blogListInfo.pageNo"
          layout=" prev, pager, next"
          hide-on-single-page
          @current-change="handlePageNoChange"
          style="text-align: right"
        ></el-pagination>
      </div>
    </div>
    <!-- 右侧 -->
    <div class="body-right" :style="{ right: rightNum + 'px' }">
      <!-- 分类 -->
      <right-category></right-category>
      <!-- 成员 -->
      <right-user></right-user>
    </div>
  </div>
</template>

<script setup>
import { ref, getCurrentInstance } from "vue";
const { proxy } = getCurrentInstance();
// api
const api = {
  loadBloglist: "/view/loadBlogList", // 获取博客列表
  // loadCategoryList: "/view/loadCategory", // 获取分类列表
  // loadUserList: "/view/loadTeamUser", // 获取成员列表
};
// 获取博客列表
const blogListInfo = ref({});
const getBloglist = async (pageNo) => {
  let result = await proxy.Request({
    url: api.loadBloglist,
    params: { pageNo: pageNo },
  });
  if (!result) {
    return;
  }
  blogListInfo.value = result.data;
};
getBloglist();
// 分页翻页
const handlePageNoChange = (pageNo) => {
  getBloglist(pageNo);
};
// 不同浏览器的innerWidth不同，因此要固定右侧目录需要动态计算定位位置
const rightNum = ref((window.innerWidth - 1150) / 2);
</script>

<style lang="scss" scoped>
.container {
  display: flex;
  min-height: calc(100vh - 120px);
  .body-left {
    width: 860px;
    margin-right: 10px;
    background-color: #fff;
    .pagination {
      margin: 10px;
    }
  }
  .body-right {
    position: fixed;
    padding: 10px;
    width: 280px;
    background-color: #fff;
  }
}
</style>
