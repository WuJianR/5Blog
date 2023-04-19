<template>
  <div>
    <el-container>
      <!-- 头部 -->
      <el-header class="Header">
        <p class="header-title">5-Blog</p>
        <div class="header-user">
          <span>欢迎回来，</span>
          <span class="username">{{ userInfo.nickName }}</span>
          <el-dropdown @command="handleCommand">
            <img :src="userInfo.avatar" class="avatar" />
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="myInfo" @click="goUserInfo">
                  <!-- <router-link to="/settings/my" class="linkTo"
                    >个人信息</router-link
                  > -->
                  个人信息
                </el-dropdown-item>
                <el-dropdown-item command="loginOut">退出</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      <!-- 下部分 -->
      <el-container class="Container">
        <!-- 下部分侧边 -->
        <el-aside class="Aside">
          <div class="btn-box">
            <el-button class="aside-btn" @click="createHtml">发布</el-button>
          </div>
          <!-- 菜单 -->
          <div class="menu">
            <ul>
              <li v-for="(menu, index) in menuList" :key="index">
                <span class="menu-title-p" @click="openCloseClick(index)">
                  <span :class="['iconfont', menu.icon, 'menu-icon']"></span>
                  <span class="menu-title">{{ menu.title }}</span>
                  <span
                    :class="[
                      'iconfont',
                      'open-close',
                      menu.open ? 'icon-open' : 'icon-close',
                    ]"
                  ></span>
                </span>

                <ul class="sub-menu" v-if="menu.open">
                  <li v-for="menuChild in menu.children" :key="menuChild.title">
                    <router-link
                      :to="menuChild.path"
                      :class="[
                        'sub-menu-item',
                        menuChild.path === activePath ? 'activeSubMenu' : '',
                      ]"
                      >{{ menuChild.title }}</router-link
                    >
                  </li>
                </ul>
              </li>
            </ul>
          </div>
        </el-aside>
        <!-- 下部分主体部分 -->
        <el-main class="Main">
          <div class="main">
            <router-view></router-view>
          </div>
        </el-main>
      </el-container>
    </el-container>
    <Dialog
      :show="progressDialog.show"
      :title="progressDialog.title"
      :buttons="progressDialog.buttons"
      @close="progressDialog.show = false"
      :show-close="false"
      :showCancel="false"
      width="400px"
    >
      <div class="progress-container">
        <div class="progress-panel">
          <el-progress
            type="circle"
            :percentage="progressInfo.progress"
            :status="progressInfo.status"
            :color="colors"
          />
        </div>
        <div class="error" v-if="progressInfo.result == 0">
          <div>生成页面出错了：{{ progressInfo.errorMsg }}</div>
          <div class="info">具体错误，请查看服务器日志</div>
        </div>
        <div
          class="success"
          v-if="progressInfo.progress == 100 && progressInfo.result == 1"
        >
          发布成功
        </div>
        <div
          class="btn-panel"
          v-if="progressInfo.progress == 100 || progressInfo.result == 0"
        >
          <el-button
            class="btn"
            type="primary"
            @click="progressDialog.show = false"
            >关闭</el-button
          >
        </div>
      </div>
    </Dialog>
  </div>
</template>
<script setup>
import { useStore } from "vuex";
import { useRouter, useRoute } from "vue-router";
import { ref, reactive, getCurrentInstance, watch } from "vue";
const { proxy } = getCurrentInstance();
const router = useRouter();
const route = useRoute();
const store = useStore();
const api = {
  getUserInfo: "getUserInfo",
  loginOut: "logout",
  createHtml: "createHtml",
  checkProgress: "checkProgress",
};
const menuList = ref([
  {
    title: "博客",
    icon: "icon-blog",
    open: true,
    children: [
      {
        title: "博客管理",
        path: "/blog/list",
      },
      {
        title: "分类管理",
        path: "/blog/category",
      },
    ],
  },
  {
    title: "专题",
    icon: "icon-zhuanti",
    open: true,
    children: [
      {
        title: "专题管理",
        path: "/special/list",
      },
    ],
  },
  {
    title: "设置",
    icon: "icon-setting",
    open: true,
    children: [
      {
        title: "个人信息设置",
        path: "/settings/my",
      },
      {
        title: "博客成员",
        path: "/settings/user",
      },
      {
        title: "系统设置",
        path: "/settings/sysInfo",
        roleType: 1,
      },
    ],
  },
  {
    title: "回收站",
    icon: "icon-delete",
    open: true,
    children: [
      {
        title: "回收站",
        path: "/recovery/list",
      },
    ],
  },
]);
const userInfo = ref({});
// 页面初始化，得到用户数据
const init = async () => {
  let result = await proxy.Request({
    url: api.getUserInfo,
  });
  if (!result) {
    return;
  }
  userInfo.value = result.data;
  userInfo.value.avatar = proxy.globalInfo.imageUrl + result.data.avatar;
  // userInfo.value.avatar = result.data.avatar;
};
init();
// 控制侧边菜单栏是否打开子栏的显示图标
const openCloseClick = (index) => {
  menuList.value[index].open = !menuList.value[index].open;
};
const handleCommand = (command) => {
  if (command === "loginOut") {
    proxy.Confirm(`你确定要删除退出吗`, async () => {
      let result = await proxy.Request({
        url: api.loginOut,
      });
      if (!result) {
        result;
      }
      proxy.Message.success("退出登录成功");
      router.push("/login");
    });
  }
};
const activePath = ref();
// 监听路由变化
watch(
  route,
  (newVal, oldVal) => {
    // console.log("---------1", newVal);
    // console.log("---------2", oldVal);
    activePath.value = newVal.path;
    // console.log(route.path);
  },
  { immediate: true, deep: true }
);
// 跳转个人信息页
const goUserInfo = () => {
  if (route.path === "/settings/my") {
    proxy.Message.warning("已在个人信息页");
  } else {
    router.push("/settings/my");
  }
};
// 监听头像变化
watch(
  () => store.state.userInfo,
  (newVal, oldVal) => {
    const avatar = proxy.globalInfo.imageUrl + newVal.avatar;
    const nickName = newVal.nickName;
    userInfo.value.nickName = nickName;
    userInfo.value.avatar = avatar;
  },
  { immediate: true, deep: true }
);

//发布
const colors = [
  { color: "#f56c6c", percentage: 20 },
  { color: "#e6a23c", percentage: 40 },
  { color: "#6f7ad3", percentage: 60 },
  { color: "#1989fa", percentage: 80 },
  { color: "#5cb87a", percentage: 100 },
];

const progressDialog = reactive({
  title: "发布",
  buttons: [],
  show: false,
});

const progressInfo = reactive({
  progress: 0,
});

let checkTimer = null;
const createHtml = async () => {
  progressDialog.show = true;
  progressInfo.progress = 0;
  progressInfo.status = undefined;
  let result = await proxy.Request({
    url: api.createHtml,
  });
  if (!result) {
    return;
  }
  checkProgress();
  checkTimer = setInterval(() => {
    checkProgress();
  }, 1000);
};
const checkProgress = async () => {
  let result = await proxy.Request({
    url: api.checkProgress,
    showLoading: false,
  });
  if (!result) {
    return;
  }
  if (result.data.result == 0) {
    progressInfo.status = "exception";
    progressInfo.errorMsg = result.data.errorMsg;
  } else {
    progressInfo.progress = result.data.progress;
  }
  progressInfo.result = result.data.result;
  if (
    (result.data.progress == 100 || result.data.result == 0) &&
    checkTimer != null
  ) {
    clearInterval(checkTimer);
  }
};
</script>

<style lang="scss" scoped>
.Header {
  border-bottom: 1px solid #ddd;
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 50px;
  .header-title {
    font-size: 25px;
  }
  .header-user {
    display: flex;
    // text-align: center;
    align-items: center;
    .username {
      color: #08f;
    }
    .el-tooltip__trigger {
      color: #000;
      font-size: 16px;
    }
    .avatar {
      width: 44px;
      height: 44px;
      border-radius: 22px;
      margin-left: 10px;
      cursor: pointer;
    }
  }
}
.Container {
  height: calc(100vh - 50px);
  .Aside {
    width: 220px;
    border-right: 1px solid #ddd;
    background-color: #f4f6f5;
    .btn-box {
      padding: 12px 10px;
    }
    .aside-btn {
      width: 100%;
      background-color: #006000;
      color: #fff;
    }
    .menu {
      padding: 0 10px 0 20px;

      .menu-title-p {
        cursor: pointer;
        border-radius: 4px;
        display: flex;
        line-height: 30px;
        .iconfont {
          color: #91949a;
        }
        .menu-icon {
          padding-left: 4px;
        }
        .open-close {
          padding-right: 4px;
        }
        .menu-title {
          flex: 1;
          color: #3f4042;
          margin-left: 10px;
        }
      }
      .menu-title-p:hover {
        background-color: #ddd;
      }
      .sub-menu {
        line-height: 20px;
        font-size: 13px;
        .sub-menu-item {
          display: block;
          padding-left: 40px;
          border-radius: 3px;
          text-decoration: none;
          color: #000;
          cursor: pointer;
        }
        .sub-menu-item:hover {
          color: #ff916f;
          background-color: #ddd;
        }
        .activeSubMenu {
          color: #ff916f;
          background-color: #ddd;
        }
      }
    }
  }
  .Main {
    background-color: #f4f6f5;
    padding: 0 !important;
    .main {
      background-color: #fff;
      height: calc(100vh - 50px);
      padding: 15px;
      border-radius: 5px;
    }
  }
}
.linkTo {
  color: #000;
}
.linkTo:hover {
  color: #08f;
}
.progress-container {
  .progress-panel {
    display: flex;
    justify-content: center;
  }

  .error {
    color: red;
    margin-top: 20px;

    .info {
      font-size: 13px;
    }
  }

  .success {
    margin-top: 20px;
    text-align: center;
    font-size: 16px;
    color: green;
  }

  .btn-panel {
    text-align: center;
    margin-top: 20px;

    .btn {
      margin: 0px auto;
    }
  }
}
</style>
