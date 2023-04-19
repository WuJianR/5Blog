<template>
  <div class="cateTitle">
    <span>博客成员</span>
    <router-link to="/user" class="router-link">更多>></router-link>
  </div>
  <div
    class="userContent"
    v-for="item in userList"
    :key="item.userId"
    @click="routerChange(item.userId)"
  >
    <div class="userCover">
      <img :src="proxy.globalInfo.imageUrl + item.avatar" alt="" />
      <div class="userMsg">
        <p class="userName">{{ item.nickName }}</p>
        <p class="userProfession">{{ item.profession }}</p>
      </div>
    </div>
    <div class="blogCount">{{ item.blogCount }}篇</div>
  </div>
</template>

<script setup>
import { ref, getCurrentInstance } from "vue";
import { useRouter } from "vue-router";
const { proxy } = getCurrentInstance();
const router = useRouter();
// api
const api = {
  loadUserList: "/view/loadTeamUser", // 获取成员列表
};
// 获取成员列表
const userList = ref({});
const getUserList = async () => {
  let result = await proxy.Request({
    url: api.loadUserList,
  });
  if (!result) {
    return;
  }
  userList.value = result.data;
};
getUserList();
// 点击成员跳转至具体成员页面
const routerChange = (userId) => {
  router.push("/user/#" + userId);
};
</script>

<style lang="scss" scoped>
.cateTitle {
  display: flex;
  padding: 10px;
  justify-content: space-between;
  border-bottom: 1px solid #7f8790;
  font-size: 14px;
  .router-link {
    font-size: 8px;
  }
}

.userContent {
  display: flex;
  justify-content: space-between;
  height: 80px;
  margin: 10px;
  .userCover {
    display: flex;
    img {
      width: 60px;
      height: 60px;
      border-radius: 30px;
      margin-right: 10px;
    }
    .userMsg {
      margin: auto;
      .userName {
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 5px;
      }
      .userProfession {
        font-size: 6px;
        color: #7f8790;
      }
    }
  }
  .blogCount {
    line-height: 80px;
    font-size: 6px;
    color: #7f8790;
  }
}
</style>
