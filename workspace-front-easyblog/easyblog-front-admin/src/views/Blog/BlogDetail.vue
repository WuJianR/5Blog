<template>
  <div>
    <Window
      :buttons="windowConfig.buttons"
      :show="windowConfig.show"
      :showCancel="false"
      @close="closeWindow"
    >
      <h2 class="title">{{ blog.title }}</h2>
      <div v-html="blog.content" class="blog-detail"></div>
    </Window>
  </div>
</template>

<script setup>
import { getCurrentInstance, reactive, ref } from "vue";
import hljs from "highlight.js";
import "highlight.js/styles/atom-one-light.css"; //样式
const { proxy } = getCurrentInstance();
const api = {
  getBlogDetail: "/blog/getBlogById",
};
const blog = ref({
  title: "",
  conetnt: "",
});
const windowConfig = reactive({
  show: false,
  buttons: [
    {
      type: "danger",
      text: "返回",
      click: (e) => {
        closeWindow();
      },
    },
  ],
});

const showDetail = async (blogId) => {
  windowConfig.show = true;
  const result = await proxy.Request({
    url: api.getBlogDetail,
    params: { blogId: blogId },
  });
  if (!result) {
    return;
  }
  blog.value = result.data;
  // console.log(blog.value);
  nextTick(() => {
    //高亮显示
    let blocks = document.querySelectorAll("pre code");
    blocks.forEach((block) => {
      hljs.highlightBlock(block);
    });
  });
};
const closeWindow = () => {
  windowConfig.show = false;
};
defineExpose({ showDetail });
</script>

<style lang="scss" scoped>
// .title {
//   font-size: 18px;
// }
.blog-detail {
  blockquote {
    padding: 0 1em;
    color: #6a737d;
    border-left: 0.25em solid #dfe2e5;
  }

  :deep(img) {
    max-width: 80%;
  }
}
</style>
