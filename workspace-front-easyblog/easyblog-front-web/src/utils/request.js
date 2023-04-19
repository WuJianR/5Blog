import axios from "axios";
import { ElLoading } from "element-plus";
import router from "@/router";
import message from "./Message";

const contentTypeForm = "application/x-www-form-urlencoded;charset=UTF-8";
const contentTypeJson = "application/json";
const contentTypeFile = "multipart/form-data";

const request = (config) => {
  let { url, params, dataType = "form", showLoading = "true" } = config;
  // 数据类型分三种：表单类型、json类型、上传文件类型
  // dataType = dataType ? dataType : "form";
  // 是否展示加载数据的遮罩层
  // showLoading = showLoading ? showLoading : true;

  let contentType = contentTypeForm; // 默认数据类型
  if (dataType === "json") {
    contentType = contentTypeJson;
  } else if (dataType === "file") {
    contentType = contentTypeFile;
    // FormData 对象用以将数据编译成键值对，以便用XMLHttpRequest来发送数据。其主要用于发送表单数据，但亦可用于发送带键数据 (keyed data)，而独立于表单使用。
      let param = new FormData();
      
      
    for (let key in params) {
      param.append(key, params[key]);
    }
    params = param;
  }
  const http = axios.create({
    baseURL: "/api",
    timeout: 10 * 1000,
    headers: {
      "Content-Type": contentType,
      "X-Requested-With": "XMLHttpRequest",
    },
  });

  let loading = null;
  // 请求拦截器
  http.interceptors.request.use(
    (config) => {
      if (showLoading) {
        // 如果需要加载数据的遮罩层就实例化一个
        loading = ElLoading.service({
          lock: true,
          text: "加载中.......",
          background: "rgba(0, 0, 0, 0.7)",
        });
      }
      return config;
    },
    (error) => {
      if (showLoading && loading) {
        // 关闭遮罩层
        loading.close();
      }
      // 界面提示错误
      message.error("发送请求失败");
      // 返回错误信息
      return Promise.reject("发送请求失败");
    }
  );
  // 响应拦截器
  http.interceptors.response.use(
    (response) => {
      // 响应请求后关闭遮罩层
      if (showLoading && loading) {
        loading.close();
      }
      // 得到响应数据
      const responseData = response.data;
      // console.log(responseData);
      // 如果响应数据的状态是错误的话再根据不同状态码code执行不同响应
      if (responseData.status == "error") {
        // 登录超时：2s后重新跳到登录页
        if (responseData.code == 901) {
          setTimeout(() => {
            router.push("/login");
          }, 2000);
          return Promise.reject("登录超时");
        }
        if (config.errorCallback) {
          config.errorCallback();
        }
        return Promise.reject(responseData.info);
      } else {
        if (responseData.code == 200) {
          return responseData;
        }
      }
      // 返回响应数据
      // return responseData;
    },
    (error) => {
      console.log(error);
      if (showLoading && loading) {
        loading.close();
      }
      return Promise.reject("网络异常");
    }
  );

  //   let result = new Promise((reslove, reject) => {
  //     http
  //       .post(url, params)
  //       .then((res) => {
  //         reslove(res);
  //       })
  //       .catch((error) => {
  //         ElMessage({
  //           message: error,
  //           type: "error",
  //         });
  //       });
  //   });
  //   return result;
  return http.post(url, params).catch((error) => {
    message.error(error);
    return null;
  });
};

export default request;
