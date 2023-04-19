<template>
  <div class="card">
    <div class="cardCover"><Cover :cover="cover"></Cover></div>
    <div>
      <router-link :to="'../blog/' + blogId" class="cardTitle">{{
        title
      }}</router-link>
      <p class="cardSummary">{{ summary }}</p>
      <div class="cardMesg">
        <span class="cardCreateTime">{{ createTime }}</span>
        <span class="cardNickName"
          >作者：<router-link :to="'/user/#' + userId" class="routerLink">{{
            nickName
          }}</router-link></span
        >
        <span class="cardCategoryName"
          >分类专栏：
          <router-link
            v-if="categoryId !== null && categoryId !== 0"
            :to="'../category/' + categoryId"
            class="routerLink"
            >{{ categoryName }}</router-link
          >
          <router-link v-else :to="'../category'" class="routerLink">{{
            categoryName
          }}</router-link>
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, getCurrentInstance } from "vue";
const { proxy } = getCurrentInstance();
const props = defineProps({
  cover: {
    type: String,
  },
  title: {
    type: String,
  },
  summary: {
    type: String,
  },
  createTime: {
    type: String,
  },
  nickName: {
    type: String,
  },
  categoryName: {
    type: String,
  },
  blogId: {
    type: String,
  },
  categoryId: {
    type: Number,
  },
  userId: {
    type: Number,
  },
});
</script>

<style lang="scss" scoped>
.card {
  border-bottom: 1px solid #1890ff;
  padding: 10px;
  display: flex;
  .cardCover {
    padding-right: 10px;
  }
  .cardTitle {
    text-decoration: none;
    font-size: 20px;
    font-weight: 300;
    color: #1890ff;
  }
  .cardSummary {
    margin: 10px 0;
    font-size: 14px;
    color: #7f8790;
    text-overflow: -o-ellipsis-lastline;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
  }
  .cardMesg {
    .cardCreateTime {
      color: #7f8790;
      margin-right: 10px;
      font-size: 12px;
    }
    .cardNickName {
      color: #7f8790;
      font-size: 12px;
      margin-right: 10px;
      routerLink {
        text-decoration: none;
        font-size: 14px;
        color: #1890ff;
      }
    }
    .cardCategoryName {
      color: #7f8790;
      font-size: 12px;
      margin-right: 10px;
      routerLink {
        text-decoration: none;
        font-size: 14px;
      }
    }
  }
}
</style>
