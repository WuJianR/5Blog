<template>
  <div>
    <el-dialog
      :show-close="showClose"
      :draggable="true"
      :model-value="show"
      :close-on-click-modal="false"
      :title="title"
      :showCancel="showCancel"
      class="cust-dialog"
      :top="top"
      :width="width"
      @close="close"
    >
      <div class="dialog-body">
        <slot></slot>
      </div>
      <template v-if="(buttons && buttons.length > 0) || showCancel">
        <div class="dialog-footer">
          <el-button link @click="close">取消</el-button>
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
    </el-dialog>
  </div>
</template>

<script setup>
// defineProps()子组件向父组件开放传递数据的通道
const props = defineProps({
  show: {
    type: Boolean,
    default: true,
  },
  title: {
    type: String,
  },
  // 控制是否展示关闭按钮
  showClose: {
    type: Boolean,
    default: true,
  },
  // 控制是否展示取消按钮
  showCancel: {
    type: Boolean,
    default: true,
  },
  top: {
    type: String,
    default: "50px",
  },
  width: {
    type: String,
    default: "500px",
  },
  buttons: {
    type: Array,
  },
});

// defineEmits()子组件调用父组件中的方法
const emit = defineEmits();
const close = () => {
  emit("close");
};
</script>

<style lang="scss" scoped>
.cust-dialog {
  .dialog-body {
    border-top: 1px solid #ddd;
    border-bottom: 1px solid #ddd;
    min-height: 80px;
  }
  .dialog-footer {
    text-align: right;
    padding: 10px 20px;
  }
}
::v-deep .el-dialog__body {
  padding: 0;
}
</style>
