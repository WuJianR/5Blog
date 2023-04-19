<template>
  <div class="cover">
    <img
      :src="proxy.globalInfo.imageUrl + cover"
      v-if="cover"
      :style="{ width: width + 'px', 'overflow-y': 'hidden' }"
    />
    <img v-else class="noImg" />
  </div>
</template>

<script setup>
import { getCurrentInstance, reactive } from "vue";

const props = defineProps({
  cover: {
    type: String,
  },
  width: {
    type: Number,
    default: 100,
  },
});
const { proxy } = getCurrentInstance();
</script>

<style lang="scss" scoped>
.cover {
  background: #ddd;
  display: flex;
  align-items: center;
  justify-content: center;
  img {
    width: 100%;
  }
  .noImg {
    width: 100%;
    background: #ddd;
  }
}
</style>
