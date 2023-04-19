<template>
  <div class="window" v-if="show">
    <div class="header">
      <span class="iconfont icon-back" @click="close"></span>
    </div>
    <div class="main">
      <!-- 标题输入框、富文本框、Markdown编辑器插槽 -->
      <slot></slot>
    </div>
    <template v-if="(buttons && buttons.length > 0) || showCancel">
      <div class="footer">
        <el-button link @click="close" v-if="showCancel">返回</el-button>
        <el-button
          v-for="(btn, index) in buttons"
          :key="index"
          :type="btn.type"
          @click="btn.click"
          size="small"
          >{{ btn.text }}</el-button
        >
      </div>
    </template>
  </div>
</template>

<script setup>
const props = defineProps({
  show: {
    type: Boolean,
    default: false,
  },
  showCancel: {
    type: Boolean,
    default: true,
  },
  buttons: {
    type: Array,
  },
});

const emit = defineEmits();
const close = () => {
  emit("close");
};
</script>

<style lang="scss" scoped>
.window {
  position: absolute;
  top: 60px;
  left: 220px;
  width: calc(100% - 220px);
  height: calc(100vh - 60px);
  background-color: #fff;
  z-index: 3;
  .header {
    .iconfont {
      margin-left: 10px;
      margin-top: 10px;
      font-size: 20px;
    }
  }
  .main {
    height: calc(100vh - 144px);
    margin: 0 10px 10px 10px;
    // height: calc(100vh - 180px);
    // border: 1px solid #ddd;
    border-radius: 5px;
    overflow: auto;
  }
  .footer {
    // width: 100%;
    line-height: 50px;
    text-align: center;
    border-top: 1px solid #ddd;
    // padding: 10px 0;
    // display: flex;
    // justify-content: center;
  }
}
:deep(.el-form-item) {
  margin-bottom: 0;
}
// ::v-deep .el-form-item {
//   margin-bottom: 0 !important;
// }
</style>
