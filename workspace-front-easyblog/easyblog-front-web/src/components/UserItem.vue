<template>
  <div class="info">
    <img
      :src="proxy.globalInfo.imageUrl + data.avatar"
      alt=""
      class="imgInfo"
    />
    <div class="textInfo">
      <div class="nickName">{{ data.nickName }}</div>

      <div class="otherInfo">
        职位：{{
          data.profession
        }}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;博客：{{
          data.blogCount
        }}篇
      </div>
      <div class="introTitle">简介：</div>
      <div class="intro" v-html="data.introduction"></div>
    </div>
  </div>
</template>

<script setup>
import { ref, getCurrentInstance } from "vue";
const { proxy } = getCurrentInstance();
const props = defineProps({
  data: {
    type: Object,
  },
});
</script>

<style lang="scss" scoped>
.info {
  display: flex;
  background-color: #fff;
  padding: 10px;
  border-bottom: 1px solid #000;
  .imgInfo {
    width: 200px;
    height: 200px;
    border-radius: 100px;
    margin: 0 20px;
  }
  .textInfo {
    flex: 1;
    padding-top: 20px;
    .nickName {
      font-weight: 600;
      font-size: 18px;
      line-height: 30px;
      color: rgb(79, 79, 79);
    }
    .otherInfo {
      font-size: 14px;
      line-height: 30px;
    }
    .introTitle {
      font-size: 14px;
      font-weight: 600;
      line-height: 30px;
    }
    .intro {
      font-size: 14px;
      :deep(img) {
        width: 80%;
      }
    }
  }
}
</style>
