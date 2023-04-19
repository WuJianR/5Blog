<template>
  <div class="cover">
    <img :src="proxy.globalInfo.imageUrl + cover" v-if="cover" />
    <img v-else class="noImg" />
  </div>
</template>

<script setup>
import { getCurrentInstance, reactive } from "vue";

const props = defineProps({
  cover: {
    type: String,
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
  width: 60px;
  img {
    width: 100%;
  }
  .noImg {
    width: 100%;
    background: #ddd;
  }
}
</style>
