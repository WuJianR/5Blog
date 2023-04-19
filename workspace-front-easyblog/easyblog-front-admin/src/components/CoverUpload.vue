<template>
  <div>
    <el-upload
      name="file"
      :show-file-list="false"
      accept=".png,.PNG,.jpg,.JPG,.jpeg,.JPEG,.gif,.GIF,.bmp,.BMP"
      :multiple="false"
      :http-request="uploadImage"
    >
      <div class="cover-upload-btn">
        <template v-if="modelValue">
          <img :src="proxy.globalInfo.imageUrl + modelValue" />
        </template>
        <span class="iconfont icon-add" v-else></span>
      </div>
    </el-upload>
  </div>
</template>
<script setup>
import { getCurrentInstance } from "vue";
const { proxy } = getCurrentInstance();
const api = {
  uploadUrl: "file/uploadImage",
};
// 子组件使用defineProps()给父组件提供传递数据的通道
const props = defineProps({
  modelValue: {
    type: String,
    default: null,
  },
});
// 子组件使用defineEmits()调用父组件中的方法
const emit = defineEmits();
const uploadImage = async (file) => {
  // console.log(file);
  let result = await proxy.Request({
    url: api.uploadUrl,
    dataType: "file",
    params: {
      file: file.file,
      type: 0, // 0: 封面，头像 1：博客图片
    },
  });
  // console.log(result);
  const fileName = result.data.fileName;
  emit("update:modelValue", fileName); // 组件间的消息传递 v-model的使用
  emit("callback", fileName); // 组件间的消息传递 emit的使用
};
</script>

<style lang="scss" scoped>
.cover-upload-btn {
  width: 130px;
  height: 130px;
  background-color: #f9f9fd;
  display: flex;
  align-items: center;
  justify-content: center;
  .iconfont {
    font-size: 50px;
    color: rgb(164, 164, 164);
  }
  img {
    width: 100%;
    // height: 100%;
  }
}
</style>
