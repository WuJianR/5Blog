<template>
  <div>
    <!-- 查询表单 -->
    <div class="searchFormData">
      <el-form :inline="true" :model="searchFormData">
        <el-form-item label="昵称">
          <el-input
            v-model="searchFormData.nickNameFuzzy"
            placeholder="支持模糊搜索"
            style="width: 220px"
            @keydown.enter="loadDataList"
            clearable
          >
          </el-input>
        </el-form-item>
        <el-form-item label="手机号">
          <el-input
            v-model="searchFormData.phoneFuzzy"
            placeholder="支持模糊搜索"
            style="width: 220px"
            @keydown.enter="loadDataList"
            clearable
          >
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="danger" @click="loadDataList">搜索</el-button>
        </el-form-item>
      </el-form>
      <el-button type="danger" @click="showDiaglog('add')">新增账号</el-button>
    </div>
    <!-- 表格 -->
    <div>
      <Table
        :columns="columns"
        :showPagination="true"
        :dataSource="tableData"
        :fetch="loadDataList"
        :options="tableOptions"
      >
        <!-- 头像列 -->
        <template #avatar="{ row }">
          <Cover :cover="row.avatar"></Cover>
        </template>
        <!-- 成员信息列 -->
        <template #introduction="{ row }">
          <div>
            <p>昵称：{{ row.nickName }}</p>
            <p>手机号：{{ row.phone }}</p>
            <p>职业：{{ row.profession }}</p>
          </div>
        </template>
        <!-- 默认编辑器列 -->
        <template #editorType="{ row }">
          <div>
            <p>{{ row.editorType === 1 ? "MarkDown" : "富文本" }}</p>
          </div>
        </template>
        <!-- 角色列 -->
        <template #roleType="{ row }">
          <div>
            <p>{{ row.roleTypeName }}</p>
          </div>
        </template>
        <!-- 状态列 -->
        <template #statusName="{ row }">
          <div>
            <p>{{ row.statusName }}</p>
          </div>
        </template>
        <!-- 时间列 -->
        <template #time="{ row }">
          <div>
            <p>创建时间：{{ row.createTime }}</p>
            <p>最后登录时间：{{ row.lastLoginTime }}</p>
          </div>
        </template>
        <!-- 操作列 -->
        <template #op="{ row }">
          <div>
            <a
              href="javaScript:void(0)"
              @click="showDiaglog('edit', row)"
              v-if="userInfo.roleType === 1"
              >修改</a
            >
            <a href="javaScript:void(0)" v-else class="not-allow">修改</a>
            <el-divider direction="vertical" />
            <a
              href="javaScript:void(0)"
              v-if="userInfo.roleType === 1"
              @click="disableUser(row)"
              >{{ row.statusName === "启用" ? "禁用" : "启用" }}</a
            >
            <a href="javaScript:void(0)" v-else class="not-allow">{{
              row.statusName === "启用" ? "禁用" : "启用"
            }}</a>
            <el-divider direction="vertical" />
            <a
              href="javaScript:void(0)"
              v-if="userInfo.roleType === 1"
              @click="showPasswordDialog(row)"
              >修改密码</a
            >
            <a href="javaScript:void(0)" v-else class="not-allow">修改密码</a>
            <el-divider direction="vertical" />
            <a
              href="javaScript:void(0)"
              v-if="userInfo.roleType === 1"
              @click="deleteUser(row)"
              >删除</a
            >
            <a href="javaScript:void(0)" v-else class="not-allow">删除</a>
            <el-divider direction="vertical" />
            <a href="javaScript:void(0)" @click="showUser(row)">预览</a>
          </div>
        </template>
      </Table>
    </div>
  </div>
  <!-- 新增、修改成员对话框配置 -->
  <Dialog
    :showCancel="true"
    :title="dialogConfig.title"
    :buttons="dialogConfig.buttons"
    :show="dialogConfig.show"
    width="800px"
    @close="closeDialog"
  >
    <el-form
      :model="formData"
      :rules="rules"
      ref="formDataRef"
      label-width="120px"
      class="form"
    >
      <el-form-item label="昵称" prop="nickName">
        <el-input
          placeholder="请输入名称"
          v-model="formData.nickName"
        ></el-input>
      </el-form-item>
      <el-form-item label="头像" prop="avatar">
        <cover-upload v-model="formData.avatar"></cover-upload>
      </el-form-item>
      <el-form-item label="手机号" prop="phone">
        <el-input
          placeholder="请输入手机号"
          v-model="formData.phone"
        ></el-input>
      </el-form-item>
      <el-form-item label="编辑器类型" prop="editorType">
        <el-select v-model="formData.editorType">
          <el-option label="富文本" :value="0" />
          <el-option label="MarkDown" :value="1" />
        </el-select>
      </el-form-item>
      <el-form-item label="职业" prop="profession">
        <el-input
          placeholder="请输入职业"
          v-model="formData.profession"
        ></el-input>
      </el-form-item>
      <el-form-item label="密码" prop="password" v-if="edit === 0">
        <el-input
          placeholder="请输入密码"
          v-model="formData.password"
          type="password"
        ></el-input>
      </el-form-item>
      <el-form-item label="确认密码" prop="rePassword" v-if="edit === 0">
        <el-input
          placeholder="请再次输入密码"
          v-model="formData.rePassword"
          type="password"
        ></el-input>
      </el-form-item>
      <el-form-item label="简介" prop="introduction">
        <div style="width: 100%">
          <EditorHtml height="200" v-model="formData.introduction"></EditorHtml>
        </div>
      </el-form-item>
    </el-form>
  </Dialog>
  <!-- 修改密码对话框 -->
  <Dialog
    :show="passwordDialogConfig.show"
    :title="passwordDialogConfig.title"
    top="200px"
    width="400px"
    :buttons="passwordDialogConfig.buttons"
    @close="closePasswordDialog"
  >
    <el-form
      class="passwordForm"
      :model="formData"
      :rules="rules"
      label-width="80px"
      ref="passwordFormRef"
      @close="passwordDialogConfig.show = false"
    >
      <el-form-item label="密码" prop="password">
        <el-input
          type="password"
          v-model="formData.password"
          placeholder="请输入密码"
        ></el-input>
      </el-form-item>
      <el-form-item label="重复密码" prop="rePassword">
        <el-input
          type="password"
          v-model="formData.rePassword"
          placeholder="请再次输入密码"
        ></el-input>
      </el-form-item>
    </el-form>
  </Dialog>
  <!-- 预览成员对话框配置 -->
  <Dialog
    :title="showUserDialogConfig.title"
    :buttons="showUserDialogConfig.buttons"
    :show="showUserDialogConfig.show"
    width="800px"
    @close="closeUserDialog"
  >
    <el-form
      :model="formData"
      :rules="rules"
      ref="formDataRef"
      label-width="120px"
      class="form"
    >
      <el-form-item label="昵称">
        <div class="userInfo">{{ formData.nickName }}</div>
      </el-form-item>
      <el-form-item label="头像">
        <img
          class="showImg"
          :src="proxy.globalInfo.imageUrl + formData.avatar"
        />
      </el-form-item>
      <el-form-item label="手机号">
        <div class="userInfo">{{ formData.phone }}</div>
      </el-form-item>
      <el-form-item label="编辑器类型">
        <div class="userInfo">
          {{ formData.editorType === 1 ? "MarkDown" : "富文本" }}
        </div>
      </el-form-item>
      <el-form-item label="职业" prop="profession">
        <div class="userInfo">{{ formData.profession }}</div>
      </el-form-item>
      <el-form-item label="简介" prop="introduction">
        <div class="userInfo" v-html="formData.introduction"></div>
      </el-form-item>
    </el-form>
  </Dialog>
</template>

<script setup>
import { getCurrentInstance, ref, reactive, nextTick } from "vue";
const { proxy } = getCurrentInstance();
const userInfo = ref(proxy.VueCookies.get("userInfo") || {});

// api
const api = {
  getUserData: "/setting/loadUser",
  saveUser: "/setting/saveTeamUser",
  deleteUser: "/setting/delUser",
  updatePassword: "/setting/updatePassword",
  updateStatus: "/setting/updateStatus",
};
// 查询表单数据
const searchFormData = reactive({});

// 展示列表数据
const loadDataList = async () => {
  let params = {
    pageNo: tableData.value.pageNo,
    pageSize: tableData.value.pageSize,
  };
  Object.assign(params, searchFormData);
  let result = await proxy.Request({
    url: api.getUserData,
    params,
  });
  if (!result) {
    return;
  }
  tableData.value = result.data;
  // console.log(tableData.value);
};
// 表格相关
const tableData = ref({});
const tableOptions = {
  extHeight: 50,
};
// 表格配置列
const columns = [
  {
    label: "头像",
    prop: "avatar",
    width: 100,
    scopedSlots: "avatar",
  },
  {
    label: "成员信息",
    prop: "introduction",
    scopedSlots: "introduction",
    // width: 250,
  },
  {
    label: "默认编辑器",
    prop: "editorType",
    scopedSlots: "editorType",
    width: 150,
  },
  {
    label: "角色",
    prop: "roleType",
    width: 150,
    scopedSlots: "roleType",
  },
  {
    label: "状态",
    prop: "statusName",
    width: 100,
    scopedSlots: "statusName",
  },
  {
    label: "时间",
    prop: "time",
    width: 300,
    scopedSlots: "time",
  },
  {
    label: "操作",
    prop: "op",
    width: 300,
    scopedSlots: "op",
  },
];
const edit = ref(0);
// 展示新增账号表单
const showDiaglog = (type, data) => {
  dialogConfig.show = true;
  nextTick(() => {
    formDataRef.value.resetFields();
    if (type === "add") {
      dialogConfig.title = "新增成员";
      formData.value = {};
      edit.value = 0;
    } else {
      dialogConfig.title = "修改成员";
      edit.value = 1;
      Object.assign(formData.value, data);
      // console.log(data);
      // formData.value = JSON.parse(JSON.stringify(data));
    }
  });
};
// 对话框配置
const dialogConfig = reactive({
  show: false,
  title: "新增成员",
  buttons: [
    {
      type: "danger",
      text: "确定",
      click: (e) => {
        submitForm();
      },
    },
  ],
});
// 对话框表单内容
const formData = ref({});
const formDataRef = ref();
// 再次输入密码校验规则
const validateRePass = (rule, value, callback) => {
  if (value !== formData.value.password) {
    callback(new Error(rule.message));
  } else {
    callback();
  }
};
// 对话框表单规则
const rules = ref({
  nickName: [{ required: true, message: "请输入成员名称" }],
  phone: [
    { required: true, message: "请输入手机号" },
    {
      validator: proxy.Verify.phone,
      trigger: "blur",
      message: "请输入正确的手机号",
    },
  ],
  password: [{ required: true, message: "请输入密码" }],
  rePassword: [
    { required: true, message: "请再次输入密码" },
    {
      validator: validateRePass,
      message: "两次输入的密码不一致",
    },
  ],
  editorType: [{ required: true, message: "请选择编辑器类型" }],
});
// 提交对话框表单
const submitForm = () => {
  formDataRef.value.validate(async (valid) => {
    if (!valid) {
      return;
    }
    let params = {};
    Object.assign(params, formData.value);
    // console.log(params);
    let result = await proxy.Request({
      url: api.saveUser,
      params: params,
    });
    if (!result) {
      return;
    }
    dialogConfig.show = false;
    proxy.Message.success("保存成功");
    loadDataList();
  });
};
// 关闭对话框
const closeDialog = () => {
  dialogConfig.show = false;
};
// 删除成员
const deleteUser = (data) => {
  proxy.Confirm(`确定要删除成员【${data.nickName}】吗？`, async () => {
    let result = await proxy.Request({
      url: api.deleteUser,
      params: { userId: data.userId },
    });
    if (!result) {
      return;
    }
    // console.log(result);
    proxy.Message.success("删除成功");
    loadDataList();
  });
};
// 禁用成员
const disableUser = async (data) => {
  let params = { userId: data.userId, status: data.status };
  params.status = params.status === 1 ? 0 : 1;
  let result = await proxy.Request({
    url: api.updateStatus,
    params: params,
  });
  if (!result) {
    return;
  }
  // console.log(result);
  proxy.Message.success("修改状态成功");
  loadDataList();
};

// 修改密码对话框配置
const passwordDialogConfig = reactive({
  show: false,
  title: "修改密码",
  buttons: [
    {
      type: "danger",
      text: "确定",
      click: (e) => {
        submitPasswordForm();
      },
    },
  ],
});
const closePasswordDialog = () => {
  passwordDialogConfig.show = false;
};
// 修改密码表单引用
const passwordFormRef = ref();
// 修改密码
const showPasswordDialog = (data) => {
  passwordDialogConfig.show = true;
  nextTick(() => {
    passwordFormRef.value.resetFields();
    formData.value = { userId: data.userId };
  });
};
const submitPasswordForm = async () => {
  const params = {
    userId: formData.value.userId,
    password: formData.value.password,
  };
  let result = await proxy.Request({
    url: api.updatePassword,
    params: params,
  });
  if (!result) {
    return;
  }
  // console.log(result);
  proxy.Message.success("修改密码成功");
  passwordDialogConfig.show = false;
};
// 对话框配置
const showUserDialogConfig = reactive({
  show: false,
  title: "预览成员",
  buttons: [
    // {
    //   type: "danger",
    //   text: "返回",
    //   click: (e) => {
    //     closeUserDialog();
    //   },
    // },
  ],
});
const closeUserDialog = () => {
  showUserDialogConfig.show = false;
};
// 预览成员
const showUser = (data) => {
  showUserDialogConfig.show = true;
  Object.assign(formData.value, data);
};
</script>

<style lang="scss" scoped>
.form {
  padding: 20px 40px 0 0;
  height: 500px;
  overflow: auto;
}
.form::-webkit-scrollbar {
  width: 6px;
  background-color: #eee;
}

.form::-webkit-scrollbar-thumb {
  background-color: #c1c1c1;

  &:hover {
    background-color: #a8a8a8;
  }

  &:active {
    background-color: #787878;
  }
}

.form {
  scrollbar-width: thin;
  scrollbar-color: #c1c1c1 #eee;
}
.passwordForm {
  padding: 20px 30px 0 2px;
}
.userInfo {
  width: 100%;
  border-radius: 5px;
  padding: 1px 11px;
  border: 1px solid #ddd;
}
.coverUpload {
  cursor: none;
}
.showImg {
  width: 130px;
  height: 130px;
}
</style>
