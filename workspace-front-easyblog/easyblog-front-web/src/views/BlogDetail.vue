<template>
  <div class="container">
    <div class="left">
      <div class="content">
        <div class="title">{{ blogDetailInfo.title }}</div>
        <div class="info">
          <span class="cardCreateTime">{{ blogDetailInfo.createTime }}</span>
          <span class="cardNickName"
            >作者：<router-link
              :to="'/user/#' + blogDetailInfo.userId"
              class="routerLink"
              >{{ blogDetailInfo.nickName }}</router-link
            ></span
          >
          <span class="cardCategoryName"
            >分类专栏：<router-link
              v-if="
                blogDetailInfo.categoryId !== null &&
                blogDetailInfo.categoryId !== 0
              "
              :to="'../category/' + blogDetailInfo.categoryId"
              class="routerLink"
              >{{ blogDetailInfo.categoryName }}</router-link
            >
            <router-link v-else :to="'../category'" class="routerLink">{{
              blogDetailInfo.categoryName
            }}</router-link>
          </span>
        </div>
        <div class="text" v-html="blogDetailInfo.content"></div>
      </div>
    </div>
    <div class="right" :style="{ left: leftNum + 'px' }">
      <div class="toc">
        <div class="tocTitle">目录结构</div>
        <div class="toc-list">
          <template v-if="tocArray.length === 0">
            <div class="no-data">未解析到目录</div>
          </template>
          <template v-else>
            <div
              v-for="item in tocArray"
              :key="item"
              class="toc-div"
              :title="item.title"
            >
              <a
                :href="'#' + item.id"
                class="toc-item"
                :style="{
                  'padding-left': (item.level - 1) * 15 + 'px',
                }"
                >{{ item.title }}</a
              >
            </div>
          </template>
        </div>
      </div>
      <!-- 分类目录 -->
      <right-category></right-category>
    </div>
  </div>
</template>

<script setup>
import { getCurrentInstance, ref, nextTick } from "vue";
import { useRoute } from "vue-router";
import hljs from "highlight.js";
import "highlight.js/styles/atom-one-light.css"; //样式
const route = useRoute();
const { proxy } = getCurrentInstance();
const api = {
  blogDetail: "/view/getBlogDetail",
};
const scrollBarWidth = ref(0);
// 不同浏览器的innerWidth不同，因此要固定右侧目录需要动态计算定位位置
const leftNum = ref(870 + (window.innerWidth - 1150) / 2);

const blogId = ref(route.params.blogId);
const blogDetailInfo = ref({});
const getBlogDetail = async () => {
  let result = await proxy.Request({
    url: api.blogDetail,
    params: {
      blogId: blogId.value,
    },
  });
  if (!result) {
    return;
  }
  blogDetailInfo.value = result.data;
  makeToc();
  // 判断是否有滚动条
  let hasScrollBar = document.body.scrollHeight > window.innerHeight;
  if (!hasScrollBar) {
    // 如果没有滚动条
    console.log(leftNum.value);
    leftNum.value = leftNum.value - 4;
  }
  highlightCode();
};
getBlogDetail();
const highlightCode = () => {
  nextTick(() => {
    //高亮显示
    let blocks = document.querySelectorAll("pre code");
    blocks.forEach((block) => {
      hljs.highlightBlock(block);
    });
  });
};
// 获取目录结构
const tocArray = ref([]);
const makeToc = () => {
  nextTick(() => {
    // 定义参与目录生成的标签
    const tocTags = ["H1", "H2", "H3", "H4", "H5", "H6"];
    // 获取所有的标题标签
    let textDom = document.querySelector(".text");
    const childNodes = textDom.childNodes;
    let index = 0;
    childNodes.forEach((item) => {
      let tagName = item.tagName;
      if (!tagName) {
        return true;
      }
      if (tocTags.includes(tagName.toUpperCase())) {
        index++;
        let id = "toc" + index;
        item.setAttribute("id", id);
        tocArray.value.push({
          id: id,
          title: item.innerText,
          level: Number.parseInt(tagName.substring(1)),
        });
      }
    });
  });
};
</script>

<style lang="scss" scoped>
.container {
  display: flex;
  min-height: calc(100vh - 120px);
  .left {
    width: 860px;
    margin-right: 10px;
    background-color: #fff;
    .content {
      margin: 15px;
    }
    .title {
      font-size: 26px;
      font-weight: 900;
    }
    .info {
      background-color: #f4f4f4;
      margin: 10px 0;
      padding: 8px 5px;
      border-radius: 2px;
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
    .text {
      margin-top: 20px;
      line-height: 26px;
      word-break: break-all;
      :deep(img) {
        max-width: 100%;
      }
    }
  }
  .right {
    padding: 10px;
    width: 280px;
    background-color: #fff;
    position: fixed;
    .toc {
      .tocTitle {
        font-size: 14px;
        padding: 10px;
        border-bottom: 1px solid #7f8790;
      }
      .toc-list {
        margin: 15px;

        .toc-div {
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          .toc-item {
            font-size: 14px;
            // color: #8173a9;
          }
          .toc-item:hover {
            color: #ff916f;
          }
        }

        .toc-div:hover {
          background-color: #f0f0f5;
          color: #ff916f;
        }
      }
    }
  }
}
</style>
