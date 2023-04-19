<template>
  <div>
    <Window
      :buttons="windowConfig.buttons"
      :show="windowConfig.show"
      @close="closeWindow"
    >
      <el-form :model="blogFormData" :rules="blogFormRules" ref="blogFormRef">
        <el-form-item prop="title">
          <div class="title-input">
            <el-input
              placeholder="输入博客标题"
              v-model="blogFormData.title"
            ></el-input>
          </div>
        </el-form-item>
        <el-form-item prop="content" style="margin-top: 20px">
          <div style="width: 100%">
            <EditorHtml
              v-if="blogFormData.editorType === 0"
              :height="editorHtmlHeight"
              v-model="blogFormData.content"
            ></EditorHtml
            ><EditorMarkdown
              :height="editorMarkdownHeight"
              v-else
              v-model="blogFormData.markdownContent"
              @htmlContent="setHtmlContent"
            ></EditorMarkdown>
          </div>
        </el-form-item>
      </el-form>
      <Dialog
        :show="dialogConfig.show"
        :title="dialogConfig.title"
        :buttons="dialogConfig.buttons"
        width="800px"
        @close="dialogConfig.show = false"
      >
        <el-form
          :model="blogFormData"
          label-width="80px"
          :rules="blogFormRules"
          style="margin: 15px"
          ref="settingsFormRef"
        >
          <!-- 博客分类 -->
          <el-form-item label="博客分类" prop="categoryId">
            <el-select
              v-model="blogFormData.categoryId"
              clearable
              placeholder="请选择分类"
              style="width: 100%"
            >
              <el-option :value="0" label="全部分类"></el-option>
              <el-option
                v-for="item in categoryList"
                :key="item.categoryId"
                :label="item.categoryName"
                :value="item.categoryId"
              ></el-option>
            </el-select>
          </el-form-item>
          <!-- 博客封面 -->
          <el-form-item label="封面">
            <cover-upload v-model="blogFormData.cover"></cover-upload>
          </el-form-item>
          <!-- 博客类型 -->
          <el-form-item label="博客类型" prop="type">
            <el-radio-group v-model="blogFormData.type">
              <el-radio :label="0">原创</el-radio>
              <el-radio :label="1">转载</el-radio>
            </el-radio-group>
          </el-form-item>
          <!-- 原文地址 -->
          <el-form-item
            label="原文地址"
            prop="reprintUrl"
            v-if="blogFormData.type === 1"
          >
            <el-input
              v-model="blogFormData.reprintUrl"
              placeholder="请输入原文地址"
            ></el-input>
          </el-form-item>
          <!-- 评论 -->
          <el-form-item label="评论" prop="allowComment">
            <div class="allow-comment">
              <el-radio-group v-model="blogFormData.allowComment">
                <el-radio :label="1">允许</el-radio>
                <el-radio :label="0">不允许</el-radio>
              </el-radio-group>
              <span class="info">
                请先在评论设置里设置好相应参数，评论才会生效</span
              >
            </div>
          </el-form-item>
          <!-- 博客摘要 -->
          <el-form-item label="博客摘要" prop="summary">
            <el-input
              v-model="blogFormData.summary"
              type="textarea"
              placeholder="未输入摘要，会读取原文部分内容作为摘要"
              :autosize="{ minRows: 3, maxRows: 3 }"
              maxlength="300"
            ></el-input>
          </el-form-item>
          <!-- 博客标签 -->
          <el-form-item label="博客标签" prop="categoryDesc">
            <div class="tag-input-panel">
              <div class="tag-list">
                <el-tag
                  v-for="(item, index) in blogFormData.tag"
                  :key="index"
                  closable
                  @close="closeTag(index)"
                  class="tag-item"
                  >{{ item }}</el-tag
                >
              </div>
              <span
                class="info"
                v-if="blogFormData.tag && blogFormData.tag.length === 0"
                >添加标签更容易被搜索引擎收录</span
              >
              <span
                class="iconfont icon-add"
                @click="showTagInputHandler"
                v-if="!showTagInput"
              ></span>
              <el-input
                class="tag-input"
                v-if="showTagInput"
                v-model="tagInputValue"
                @blur="tagInputResult"
                @keydown.enter="tagInputResult"
              ></el-input></div
          ></el-form-item>
        </el-form>
      </Dialog>
    </Window>
  </div>
</template>

<script setup>
import {
  ref,
  reactive,
  getCurrentInstance,
  nextTick,
  onMounted,
  onUnmounted,
} from "vue";
const editorMarkdownHeight = window.innerHeight - 50 - 10 - 22 - 30 - 65 - 40;
const editorHtmlHeight = window.innerHeight - 50 - 10 - 22 - 30 - 65 - 105 - 20;
const api = {
  loadCategory: "/category/loadAllCategory4Blog",
  saveBlog: "/blog/saveBlog",
  autoSaveBlog: "/blog/autoSaveBlog",
  getUserInfo: "/getUserInfo",
  getBlogDetail: "/blog/getBlogById",
  deleteBlog: "/blog/recoveryBlog",
};
const { proxy } = getCurrentInstance();
// 新增、修改博客弹出框配置
const windowConfig = reactive({
  show: false,
  buttons: [
    {
      type: "danger",
      text: "确定",
      click: (e) => {
        showSettings();
      },
    },
  ],
});

// 获取博客分类列表
const categoryList = ref([]);
const loadCategoryList = async () => {
  let result = await proxy.Request({
    url: api.loadCategory,
  });
  categoryList.value = result.data;
  // console.log(categoryList);
};
// 编辑器内容
const blogFormData = ref({});
// 编辑器表单的引用
const blogFormRef = ref(null);
// 第一步提交 展示配置表单弹窗
const showSettings = () => {
  blogFormRef.value.validate(async (valid) => {
    if (!valid) {
      return;
    }
    blogFormData.tag = blogFormData.tag == null ? [] : blogFormData.tag;
    dialogConfig.show = true;
  });
};
// 博客dialog设置
const dialogConfig = reactive({
  show: false,
  title: "博客设置",
  buttons: [
    {
      type: "danger",
      text: "确定",
      click: (e) => {
        submitBlog();
      },
    },
  ],
});
// 第二步提交，提交博客
const settingsFormRef = ref();
// 关闭新增、修改博客窗口
const emit = defineEmits();
const closeWindow = () => {
  windowConfig.show = false;
  emit("callback");
  if (timer.value !== null) {
    clearTimer();
  }
};
onMounted(() => {
  loadCategoryList();
});
onUnmounted(() => {
  clearTimer();
});
const submitBlog = () => {
  settingsFormRef.value.validate(async (valid) => {
    if (!valid) {
      return;
    }
    const params = {};
    Object.assign(params, blogFormData.value);
    params.tag = params.tag.join("|");
    // console.log(params);
    const result = await proxy.Request({
      url: api.saveBlog,
      params: params,
    });
    if (!result) {
      return;
    }
    proxy.Message.success("发布博客成功");
    dialogConfig.show = false;
    closeWindow();
  });
};

//markdown编辑器设置html内容
const setHtmlContent = (htmlContent) => {
  blogFormData.value.content = htmlContent;
};
// 表单规则
const blogFormRules = reactive({
  categoryId: [{ required: true, message: "请选择分类", trigger: "blur" }],
  title: [{ required: true, message: "请输入标题", trigger: "blur" }],
  content: [{ required: true, message: "请输入正文", trigger: "blur" }],
  type: [{ required: true, message: "请选择博客类型", trigger: "blur" }],
  reprintUrl: [{ required: true, message: "请输入原文地址", trigger: "blur" }],
  allowComment: [
    { required: true, message: "请选择是否允许评论", trigger: "blur" },
  ],
});
// 删除标签
const closeTag = (index) => {
  blogFormData.value.tag.splice(index, 1);
};
// 是否显示tag输入框
const showTagInput = ref(false);
const showTagInputHandler = () => {
  showTagInput.value = true;
};

// 保存tag输入框的值
const tagInputValue = ref(null);
const tagInputResult = () => {
  if (tagInputValue.value == undefined) {
    showTagInput.value = false;
    return;
  }
  if (
    typeof tagInputValue.value === "string" &&
    tagInputValue.value.trim() == ""
  ) {
    showTagInput.value = false;
    tagInputValue.value = undefined;
    return;
  }
  showTagInput.value = false;
  if (blogFormData.value.tag.indexOf(tagInputValue.value) == -1) {
    blogFormData.value.tag.push(tagInputValue.value);
  }
  tagInputValue.value = undefined;
};
// 自动保存
const autoSave = async () => {
  if (
    blogFormData.value.title == undefined ||
    blogFormData.value.content == undefined ||
    timer.value == null ||
    dialogConfig.show
  ) {
    return;
  }
  const params = {};
  Object.assign(params, blogFormData.value);
  let result = await proxy.Request({
    url: api.autoSaveBlog,
    showLoading: false,
    params: params,
  });
  if (!result) {
    return;
  }
  blogFormData.value.blogId = result.data;
};

let timer = ref(null);
// 计时器开始
const startTimer = () => {
  timer.value = setInterval(() => {
    autoSave();
  }, 3000);
};
// 清除计时器
const clearTimer = () => {
  if (timer.value !== null) {
    clearInterval(timer.value);
    timer.value = null;
  }
};
// 获取用户信息——得到用户的编辑器类型
const getUserInfo = async () => {
  const result = await proxy.Request({
    url: api.getUserInfo,
  });
  if (!result) {
    return;
  }
  blogFormData.value.editorType = result.data.editorType;
  // console.log(blogFormData.value);
};
// 初始化
const init = (type, data) => {
  startTimer();
  windowConfig.show = true;
  nextTick(() => {
    blogFormRef.value.resetFields();
    blogFormData.value = { tag: [] };
    if (type === "add") {
      getUserInfo();
    } else {
      getBlogDetail(data.blogId);
    }
  });
};
// 修改博客
const getBlogDetail = async (blogId) => {
  const result = await proxy.Request({
    url: api.getBlogDetail,
    params: { blogId: blogId },
  });
  if (!result) {
    return;
  }
  blogFormData.value = result.data;
  if (result.data.tag) {
    blogFormData.value.tag = result.data.tag.split("|");
  } else {
    blogFormData.value.tag = [];
  }
  // console.log(blogFormData.value.tag);
  // console.log(result);
};
// 删除博客
const deleteBlog = (row) => {
  proxy.Confirm(`确定要删除名为【${row.title}】的博客吗？`, async () => {
    const result = await proxy.Request({
      url: api.deleteBlog,
      params: { blogId: row.blogId },
    });
    if (!result) {
      return;
    }
    // console.log(result);
    proxy.Message.success("删除博客成功");
    emit("callback");
  });
};
// 暴露此组件的init、deleteBlog方法，便于其父组件通过ref的方式调用
defineExpose({ init, deleteBlog });
</script>

<style lang="scss" scoped>
.title-input {
  width: 100%;
  border-bottom: 1px solid #ddd;
  // margin-bottom: 20px;
  ::v-deep .el-input__wrapper {
    box-shadow: none;
  }
  input {
    font-size: 18px;
  }
}
.allow-comment {
  .info {
    color: rgb(175, 175, 175);
    font-size: 12px;
  }
}
.tag-input-panel {
  display: flex;
  align-items: center;
  .tag-list {
    margin-right: 10px;
    .tag-item {
      margin-right: 10px;
    }
  }
  .info {
    color: rgb(175, 175, 175);
    font-size: 12px;
    margin-right: 10px;
  }
  .iconfont {
    font-size: 16px;
    cursor: pointer;
  }
  .tag-input {
    width: 80px;
    height: 23px;
  }
}
</style>
