<template>
  <div>
    <el-button
      type="danger"
      size="small"
      @click="showDialog('add')"
      :disabled="userInfo.roleType !== 1"
      >新增分类</el-button
    >
    <!-- 表格 -->
    <Table
      :columns="columns"
      :showPagination="false"
      :dataSource="tableData"
      :fetch="loadDataList"
      :options="tableOptions"
    >
      <!-- 封面列 -->
      <template #cover="{ row }">
        <!-- 封面组件 -->
        <Cover :cover="row.cover"></Cover>
      </template>
      <!-- 操作列 -->
      <template #op="{ index, row }">
        <div class="op">
          <a
            href="javascript:void(0)"
            v-if="userInfo.roleType === 1"
            @click="showDialog('update', row)"
            >修改</a
          >
          <a href="javascript:void(0)" v-else class="not-allow">修改</a>
          <el-divider direction="vertical" />
          <a
            href="javascript:void(0)"
            v-if="userInfo.roleType === 1"
            @click="delCategory(row)"
            >删除</a
          >
          <a href="javascript:void(0)" v-else class="not-allow">删除</a>
          <el-divider direction="vertical" />
          <a
            href="javascript:void(0)"
            v-if="userInfo.roleType === 1"
            @click="changeSortCategory(index, 'up')"
            >上移</a
          >
          <a href="javascript:void(0)" v-else class="not-allow">上移</a>
          <el-divider direction="vertical" />
          <a
            href="javascript:void(0)"
            v-if="userInfo.roleType === 1"
            @click="changeSortCategory(index, 'down')"
            >下移</a
          >
          <a href="javascript:void(0)" v-else class="not-allow">下移</a>
        </div>
      </template>
    </Table>
    <!-- 新增/编辑对话框 -->
    <Dialog
      :show="dialogConfig.show"
      :title="dialogConfig.title"
      :buttons="dialogConfig.buttons"
      @close="closeDialog"
      width="500px"
    >
      <!-- 新增/编辑表单 -->
      <el-form
        class="categoryForm"
        :model="formData"
        :rules="rules"
        ref="formDataRef"
        label-width="80px"
      >
        <el-form-item label="名称" prop="categoryName">
          <el-input
            placeholder="请输入名称"
            v-model="formData.categoryName"
          ></el-input>
        </el-form-item>
        <el-form-item label="封面" prop="cover">
          <!-- 上传文件组件 -->
          <CoverUpload v-model="formData.cover"></CoverUpload>
        </el-form-item>
        <el-form-item label="简介" prop="categoryDesc">
          <el-input
            v-model="formData.categoryDesc"
            type="textarea"
            placeholder="请输入简介"
            :autosize="{ minRows: 4, maxRows: 4 }"
          >
          </el-input>
        </el-form-item>
      </el-form>
    </Dialog>
  </div>
</template>
<script setup>
import { getCurrentInstance, nextTick, reactive, ref } from "vue";
const { proxy } = getCurrentInstance();
const userInfo = ref(proxy.VueCookies.get("userInfo") || {});
// api
const api = {
  loadDataList: "/category/loadAllCategory4Blog",
  saveCategory: "/category/saveCategory4Blog",
  changeCategorySort: "/category/changeCategorySort4Blog",
  deleteCategory: "/category/delCategory4Blog",
};
// 表格头部配置
const columns = [
  {
    label: "封面",
    prop: "cover",
    width: 100,
    scopedSlots: "cover",
  },
  {
    label: "名称",
    prop: "categoryName",
    width: 200,
  },
  {
    label: "简介",
    prop: "categoryDesc",
  },
  {
    label: "博客数量",
    prop: "blogCount",
    width: 100,
  },
  {
    label: "操作",
    prop: "op",
    width: 200,
    scopedSlots: "op",
  },
];
// 表格数据相关
const tableData = reactive({});
const tableOptions = {
  extHeight: 50,
};
const loadDataList = async () => {
  let result = await proxy.Request({
    url: api.loadDataList,
  });
  if (!result) {
    return;
  }
  // console.log(result);
  tableData.list = result.data;
};
// 对话框配置
const dialogConfig = reactive({
  show: false,
  title: "标题",
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
// 关闭对话框事件
const closeDialog = () => {
  dialogConfig.show = false;
  formDataRef.value.resetFields();
};

// 对话框表单内容
const formData = ref({});
const formDataRef = ref();
const rules = ref({
  categoryName: [{ required: true, message: "请输入分类名称" }],
});

// 展示对话框事件
const showDialog = (type, data) => {
  dialogConfig.show = true;
  nextTick(() => {
    formDataRef.value.resetFields();
    if (type === "add") {
      dialogConfig.title = "新增分类";
      formData.value = {};
    } else {
      dialogConfig.title = "修改分类";
      // Object.assign(formData.value, data);
      formData.value = JSON.parse(JSON.stringify(data));
    }
  });
};

// 提交对话框表单事件
const submitForm = () => {
  formDataRef.value.validate(async (valid) => {
    if (!valid) {
      return;
    }
    let params = {};
    Object.assign(params, formData.value);
    let result = await proxy.Request({
      url: api.saveCategory,
      params: params,
    });
    if (!result) {
      return;
    }
    // console.log(result);
    dialogConfig.show = false;
    proxy.Message.success("保存成功");
    loadDataList();
  });
};
// 删除分类
const delCategory = (data) => {
  proxy.Confirm(`你确定要删除【${data.categoryName}】吗?`, async () => {
    let result = await proxy.Request({
      url: api.deleteCategory,
      params: { categoryId: data.categoryId },
    });
    if (!result) {
      return;
    }
    // console.log(result);
    proxy.Message.success("删除成功");
    loadDataList();
  });
};
// 改变排序顺序
const changeSortCategory = async (index, type) => {
  const categoryList = tableData.list;
  if (type === "up" && index === 0) {
    proxy.Message.warning("已是最顶部，无法上移");
    return;
  }
  if (type === "down" && index === categoryList.length - 1) {
    proxy.Message.warning("已是最底部，无法下移");
    return;
  }
  const temp = categoryList[index];
  const number = type === "up" ? -1 : 1;
  categoryList.splice(index, 1);
  categoryList.splice(index + number, 0, temp);
  let result = await proxy.Request({
    url: api.changeCategorySort,
    params: categoryList,
    dataType: "json",
  });
  if (!result) {
    return;
  }
  if (type === "up") {
    proxy.Message.success("上移分类成功");
  } else {
    proxy.Message.success("下移分类成功");
  }
  // console.log(result);
};
</script>

<style lang="scss" scoped>
.categoryForm {
  padding: 20px 30px 10px 5px;
}
</style>
