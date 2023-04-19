<template>
  <div class="login-container">
    <div class="login-panel">
      <div class="login-title">用户登录</div>
      <el-form :model="loginForm" :rules="loginFormRules" ref="loginFormRef">
        <el-form-item label="" prop="account">
          <el-input v-model="loginForm.account" placeholder="请输入账号">
            <template #prefix>
              <el-icon class="iconfont icon-account"></el-icon>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item label="" prop="password">
          <el-input
            type="password"
            v-model="loginForm.password"
            placeholder="请输入密码"
          >
            <template #prefix>
              <el-icon class="iconfont icon-password"></el-icon>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item prop="checkCode">
          <div class="check-code-panel">
            <el-input
              v-model="loginForm.checkCode"
              placeholder="请输入验证码"
              class="input-panel"
              @keyup.enter="login"
            >
            </el-input
            ><img
              :src="checkCodeUrl"
              alt=""
              class="checkCode-panel"
              @click="refreshCheckCode"
            />
          </div>
        </el-form-item>
        <el-form-item label="">
          <el-checkbox v-model="loginForm.rememberMe">记住我</el-checkbox>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :style="{ width: '100%' }" @click="login"
            >登录</el-button
          >
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
// md5消息摘要加密算法，属hash算法一类
import md5 from "js-md5";
import { useRouter } from "vue-router";
import { getCurrentInstance, reactive, ref } from "vue";

const router = useRouter();
const { proxy } = getCurrentInstance();
// console.log(getCurrentInstance());
// console.log(proxy);
// 接口
const loginApi = {
  checkCode: "api/checkCode",
  login: "/login",
};
// 验证码
const checkCodeUrl = ref(loginApi.checkCode);
// 刷新验证码
const refreshCheckCode = () => {
  checkCodeUrl.value = loginApi.checkCode + "?" + new Date().getTime();
};
// 表单引用
const loginFormRef = ref();
// 登录表单
const loginForm = reactive({
  account: "",
  password: "",
  checkCode: "",
  rememberMe: false,
});
// 登录表单验证规则
const loginFormRules = reactive({
  account: [
    {
      required: true,
      message: "请输入用户名",
      trigger: "blur",
    },
  ],
  password: [
    {
      required: true,
      message: "请输入密码",
      trigger: "blur",
    },
  ],
  checkCode: [
    {
      required: true,
      message: "请输入验证码",
      trigger: "blur",
    },
  ],
});

// 初始化页面 主要用于记住账号密码
const init = () => {
  const loginInfo = proxy.VueCookies.get("loginInfo");
  if (!loginInfo) {
    return;
  }
  Object.assign(loginForm, loginInfo);
};
init();

// 点击登录
const login = () => {
  loginFormRef.value.validate(async (valid) => {
    // 校验失败直接返回
    if (!valid) {
      return;
    }

    // 初始化时避免密码被重复md5加密，导致记住密码功能失效
    let cookiesLoginInfo = proxy.VueCookies.get("loginInfo");
    let cookiePassword =
      cookiesLoginInfo == null ? null : cookiesLoginInfo.password;

    if (loginForm.password !== cookiePassword) {
      loginForm.password = md5(loginForm.password);
    }

    // 请求参数
    let params = {
      account: loginForm.account,
      // password: md5(loginForm.password),
      password: loginForm.password,
      checkCode: loginForm.checkCode,
    };
    // 请求返回的数据
    let result = await proxy.Request({
      url: loginApi.login,
      params: params,
      errorCallback: () => {
        refreshCheckCode();
      },
    });
    if (!result) {
      return;
    }
    proxy.Message.success("登录成功");
    router.push("/home");
    // 登录信息
    const loginInfo = {
      account: params.account,
      password: params.password,
      rememberMe: loginForm.rememberMe,
    };
    // 存储用户信息至cookie，并设置期限永不过期
    proxy.VueCookies.set("userInfo", result.data, 0);
    // 如果勾选了记住我框，则保存登录信息7天;
    if (loginForm.rememberMe == 1) {
      proxy.VueCookies.set("loginInfo", loginInfo, "7d");
    }
  });
};
</script>

<style lang="scss" scoped>
.login-container {
  width: 100%;
  height: calc(100vh);
  background-size: cover;
  background-position: center;
  background-image: url(../assets/images/login_bg.jpg);
  .login-panel {
    width: 350px;
    padding: 20px;
    background: rgba(255, 255, 255, 0.7);
    border-radius: 10px;
    box-shadow: 2px 2px 10px #ddd;
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    .login-title {
      font-size: 20px;
      font-weight: 900;
      text-align: center;
      margin-bottom: 10px;
    }
    .check-code-panel {
      display: flex;
      align-items: center;
      .input-panel {
        flex: 1;
        margin-right: 5px;
      }
      .checkCode-panel {
        height: 30px;
        cursor: pointer;
      }
    }
  }
}
</style>
