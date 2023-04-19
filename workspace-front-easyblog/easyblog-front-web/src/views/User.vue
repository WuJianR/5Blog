<template>
  <user-item
    :id="item.userId"
    v-for="item in teamUser"
    :key="item"
    :data="item"
  ></user-item>
</template>

<script setup>
import { ref, getCurrentInstance, nextTick } from "vue";

const { proxy } = getCurrentInstance();
const api = {
  loadTeamUser: "/view/loadTeamUser",
};

const teamUser = ref([]);
const loadTeamUser = async () => {
  const result = await proxy.Request({
    url: api.loadTeamUser,
  });
  if (!result) {
    return;
  }
  teamUser.value = result.data;
  nextTick(() => {
    let url = document.location.href;
    if (url.indexOf("#") !== -1) {
      let hashId = url.substring(url.indexOf("#") + 1);
      document.getElementById(hashId).scrollIntoView();
    }
  });
};
loadTeamUser();
</script>

<style lang="scss" scoped></style>
