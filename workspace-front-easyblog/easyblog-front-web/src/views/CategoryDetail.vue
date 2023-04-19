<template>
  <div class="container">
    <div class="body-left">
      <div class="categoryHeader">
        <img :src="proxy.globalInfo.imageUrl + categoryDetail.cover" alt="" />
        <div class="content">
          <div class="categoryName">{{ categoryDetail.categoryName }}</div>
          <div class="categoryDesc" :title="categoryDetail.categoryDesc">
            {{ categoryDetail.categoryDesc }}
          </div>
          <p class="blogCount">文章数：{{ categoryDetail.blogCount }}</p>
        </div>
      </div>
      <div class="blogList">
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
      </div>
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
    </div>
  </div>
</template>

<script setup>
import { ref, getCurrentInstance } from "vue";
import { useRoute } from "vue-router";
const { proxy } = getCurrentInstance();
const route = useRoute();
// api
const api = {
  loadBloglist: "/view/loadBlogList", // 获取博客列表
  getCategoryDetail: "/view/getCategory", // 获取分类详情
};
const categoryId = ref(route.params.categoryId);
// 获取博客列表
const blogListInfo = ref({});
const getBloglist = async (pageNo) => {
  let result = await proxy.Request({
    url: api.loadBloglist,
    params: {
      pageNo: pageNo,
      categoryId: categoryId.value,
    },
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

// 获取分类详情
const categoryDetail = ref({});
const getCategoryDetail = async () => {
  const result = await proxy.Request({
    url: api.getCategoryDetail,
    params: {
      categoryId: categoryId.value,
    },
  });
  if (!result) {
    return;
  }
  categoryDetail.value = result.data;
};
getCategoryDetail();
</script>

<style lang="scss" scoped>
.container {
  display: flex;
  min-height: calc(100vh - 120px);
  .body-left {
    width: 860px;
    margin-right: 10px;
    // background-color: #fff;
    .categoryHeader {
      width: 100%;
      height: 100px;
      margin-bottom: 10px;
      padding: 10px;
      display: flex;
      background-color: #fff;
      img {
        width: 80px;
        height: 80px;
        border-radius: 4px;
        margin-right: 10px;
      }
      .content {
        .categoryName {
          font-size: 18px;
          font-weight: 600;
        }
        .categoryDesc {
          margin: 5px 0;
          font-size: 14px;
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 1;
          line-clamp: 1;
          -webkit-box-orient: vertical;
        }
        .blogCount {
          font-size: 14px;
          color: #7f8790;
        }
      }
    }
    .blogList {
      background-color: #fff;
    }
    .pagination {
      margin-top: 10px;
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
