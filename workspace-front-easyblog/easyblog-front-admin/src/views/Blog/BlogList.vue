<template>
  <div>
    <!-- 查询表单 -->
    <div class="searchFormData">
      <el-form :inline="true" :model="searchFormData">
        <el-form-item label="标题">
          <el-input
            style="width: 220px"
            v-model="searchFormData.titleFuzzy"
            placeholder="支持模糊搜索"
            clearable
            @keydown.enter="loadDataList"
          ></el-input>
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="searchFormData.status"
            clearable
            placeholder="选择状态过滤"
            @change="loadDataList"
          >
            <el-option label="草稿" :value="0" />
            <el-option label="已发布" :value="1" />
          </el-select>
        </el-form-item>
        <el-form-item label="分类">
          <el-select
            v-model="searchFormData.categoryId"
            clearable
            placeholder="请选择"
            @change="loadDataList"
          >
            <el-option
              v-for="item in categoryList"
              :key="item.categoryId"
              :label="item.categoryName"
              :value="item.categoryId"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="danger" @click="loadDataList">搜索</el-button>
        </el-form-item>
      </el-form>
      <el-button type="danger" @click="showWindow('add')">新增博客</el-button>
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
        <!-- 封面列 -->
        <template #cover="{ row }">
          <Cover :cover="row.cover"></Cover>
        </template>
        <!-- 文章信息列 -->
        <template #blogInfo="{ row }">
          <div>
            <p>标题：{{ row.title }}</p>
            <p>分类：{{ row.categoryName }}</p>
            <p>作者：{{ row.nickName }}</p>
          </div>
        </template>
        <!-- 类型列 -->
        <template #typeName="{ row }">
          <div>
            <p>{{ row.type === 1 ? "转载" : "原创" }}</p>
            <p v-if="row.type === 1">转载地址：{{ row.reprintUrl }}</p>
          </div>
        </template>
        <!-- 状态列 -->
        <template #statusName="{ row }">
          <p v-if="row.status === 0" style="color: red">草稿</p>
          <p v-else style="color: green">已发布</p>
        </template>
        <!-- 时间列 -->
        <template #time="{ row }">
          <div>
            <p>创建时间：{{ row.createTime }}</p>
            <p>更新时间：{{ row.lastUpdateTime }}</p>
          </div>
        </template>
        <!-- 操作列 -->
        <template #op="{ row }">
          <div>
            <a
              href="javascript:void(0)"
              @click="showWindow('edit', row)"
              v-if="userInfo.userId === row.userId"
              >修改</a
            >
            <a href="javascript:void(0)" v-else class="not-allow">修改</a>
            <el-divider direction="vertical" />
            <a
              href="javascript:void(0)"
              @click="delBlog(row)"
              v-if="userInfo.userId === row.userId"
              >删除</a
            >
            <a href="javascript:void(0)" v-else class="not-allow">删除</a>
            <el-divider direction="vertical" />
            <a href="javascript:void(0)" @click="showBlogDetail(row)">预览</a>
          </div>
        </template>
      </Table>
      <BlogEdit ref="blogEditRef" @callback="loadDataList"></BlogEdit>
      <BlogDetail ref="blogDetailRef"></BlogDetail>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, getCurrentInstance } from "vue";
import BlogEdit from "./BlogEdit.vue";
import BlogDetail from "./BlogDetail.vue";
const { proxy } = getCurrentInstance();

const userInfo = ref(proxy.VueCookies.get("userInfo") || {});
// api
const api = {
  loadCategory: "/category/loadAllCategory4Blog",
  loadDataList: "/blog/loadBlog",
  delBlog: "/blog/recoveryBlog",
};
// 查询参数
const searchFormData = reactive({});
const categoryList = ref([]);
// 获取分类列表
const loadCategoryList = async () => {
  let result = await proxy.Request({
    url: api.loadCategory,
  });
  categoryList.value = result.data;
  // console.log(categoryList);
};
loadCategoryList();
// 列表
const columns = [
  {
    label: "封面",
    prop: "cover",
    width: 100,
    scopedSlots: "cover",
  },
  {
    label: "文章信息",
    prop: "blogInfo",
    scopedSlots: "blogInfo",
  },
  {
    label: "编辑器",
    prop: "editorTypeName",
    width: 150,
  },
  {
    label: "类型",
    prop: "typeName",
    width: 100,
    scopedSlots: "typeName",
  },
  {
    label: "评论",
    prop: "allowCommentTypeName",
    width: 100,
  },
  {
    label: "状态",
    prop: "status",
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
    width: 200,
    scopedSlots: "op",
  },
];
// 表格相关
const tableData = ref({});
const tableOptions = {
  extHeight: 50,
};
// 获取blog数据列表
const loadDataList = async () => {
  let params = {
    pageNo: tableData.value.pageNo,
    pageSize: tableData.value.pageSize,
  };

  Object.assign(params, searchFormData);
  let result = await proxy.Request({
    url: api.loadDataList,
    params,
  });
  if (!result) {
    return;
  }
  // console.log(result.data);
  tableData.value = result.data;
};
loadDataList();
// 展示新增、修改博客的对话框
const blogEditRef = ref(null);
const showWindow = (type, data) => {
  // 通过ref的方式来调用子组件中的方法init(),并将此组件中的数据作为参数传入
  blogEditRef.value.init(type, data);
};
// 删除博客
const delBlog = (row) => {
  // console.log(row);
  blogEditRef.value.deleteBlog(row);
  // loadDataList(); // 一个疑问：
};
// 展示博客详情页
const blogDetailRef = ref(null);
const showBlogDetail = (row) => {
  blogDetailRef.value.showDetail(row.blogId);
};
</script>

<style lang="scss" scoped></style>
