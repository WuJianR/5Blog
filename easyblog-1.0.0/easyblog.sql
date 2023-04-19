/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50614
Source Host           : localhost:3306
Source Database       : easyblog

Target Server Type    : MYSQL
Target Server Version : 50614
File Encoding         : 65001

Date: 2022-09-25 19:34:37
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for blog
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog` (
  `blog_id` varchar(10) NOT NULL COMMENT '博客ID',
  `p_blog_id` varchar(10) DEFAULT NULL COMMENT '父ID',
  `title` varchar(200) DEFAULT NULL COMMENT '标题',
  `category_id` int(11) DEFAULT NULL COMMENT '分类ID',
  `category_name` varchar(100) DEFAULT NULL COMMENT '分类名称',
  `cover` varchar(100) DEFAULT NULL COMMENT '封面',
  `summary` varchar(300) DEFAULT NULL COMMENT '摘要',
  `content` mediumtext COMMENT '内容',
  `markdown_content` text COMMENT 'markdown编辑内容',
  `editor_type` tinyint(4) DEFAULT NULL COMMENT '0:富文本 1:markdown编辑器',
  `tag` varchar(200) DEFAULT NULL COMMENT '标签',
  `type` tinyint(4) DEFAULT NULL COMMENT '0:原创 1:转载',
  `reprint_url` varchar(200) DEFAULT NULL COMMENT '转载地址',
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `nick_name` varchar(20) DEFAULT NULL COMMENT '昵称',
  `allow_comment` tinyint(4) DEFAULT NULL COMMENT '0:不允许评论 1:允许评论',
  `status` tinyint(4) DEFAULT '1' COMMENT '0:草稿 1:已发布',
  `del_type` tinyint(4) DEFAULT NULL COMMENT '0:删除 1:正常',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `last_update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `blog_type` tinyint(4) DEFAULT NULL COMMENT '0:博客  1:专题',
  `sort` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`blog_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='博客';

-- ----------------------------
-- Records of blog
-- ----------------------------
INSERT INTO `blog` VALUES ('bXclKZTgbf', 'tSNqhoJdWN', '安装后端程序', '10028', 'EasyBlog文档', null, null, '<p data-v-md-line=\"1\">安装后端程序 文档：http://www.wuhancoder.com/special/vbbStsCMXs.html</p>\n', '安装后端程序 文档：http://www.wuhancoder.com/special/vbbStsCMXs.html', '1', null, '0', null, '100000', '多多洛2020', '1', '1', '1', '2022-09-25 11:20:18', '2022-09-25 11:20:36', '1', '1');
INSERT INTO `blog` VALUES ('egTFAnQNsa', 'GeLsGNuzcn', 'web端', '10028', 'EasyBlog文档', null, null, '<p data-v-md-line=\"1\">web端接口文档地址：http://www.wuhancoder.com/special/wBURpKFtiT.html</p>\n', 'web端接口文档地址：http://www.wuhancoder.com/special/wBURpKFtiT.html', '1', null, '0', null, '100000', '多多洛2020', '1', '1', '1', '2022-09-25 11:19:21', '2022-09-25 11:19:40', '1', '2');
INSERT INTO `blog` VALUES ('GeLsGNuzcn', '0', '接口文档', '10028', 'EasyBlog文档', null, null, '<p data-v-md-line=\"1\">接口文档地址：http://www.wuhancoder.com/special/azvNIIFQCy.html</p>\n', '接口文档地址：http://www.wuhancoder.com/special/azvNIIFQCy.html', '1', null, '0', null, '100000', '多多洛2020', '1', '1', '1', '2022-09-25 11:18:36', '2022-09-25 11:18:49', '1', '2');
INSERT INTO `blog` VALUES ('nReaunNBIO', null, 'EasyBlog', null, null, null, null, '', '', '1', null, null, null, '100000', '多多洛2020', null, '0', '0', '2022-09-25 11:17:05', '2022-09-25 11:18:22', '1', null);
INSERT INTO `blog` VALUES ('oPOCJVYgTN', '', 'EasyBlog 轻博客', '10027', 'EasyBlog', '', 'EasyBlog是一款可以生成静态页面的团队博客，演示地址：http://www.wuhancoder.com/', '<p data-v-md-line=\"1\">EasyBlog 是一款可以生成静态页面的团队博客，演示地址：http://www.wuhancoder.com/</p>\n', 'EasyBlog 是一款可以生成静态页面的团队博客，演示地址：http://www.wuhancoder.com/\n', '1', 'EasyBlog', '0', '', '100000', '多多洛2020', '1', '1', '1', '2022-09-25 11:16:14', '2022-09-25 13:29:34', '0', null);
INSERT INTO `blog` VALUES ('oYltCOuIWy', 'GeLsGNuzcn', '管理端', '10028', 'EasyBlog文档', null, null, '<p data-v-md-line=\"1\">管理端接口地址：http://www.wuhancoder.com/special/cqzKWftzyr.html</p>\n', '管理端接口地址：http://www.wuhancoder.com/special/cqzKWftzyr.html', '1', null, '0', null, '100000', '多多洛2020', '1', '1', '1', '2022-09-25 11:18:57', '2022-09-25 11:19:10', '1', '1');
INSERT INTO `blog` VALUES ('tSNqhoJdWN', '0', '后端服务部署', '10028', 'EasyBlog文档', null, null, '<p data-v-md-line=\"1\">后端服务部署 地址:http://www.wuhancoder.com/special/gTvGKLsNNZ.html</p>\n', '后端服务部署 地址:http://www.wuhancoder.com/special/gTvGKLsNNZ.html', '1', null, '0', null, '100000', '多多洛2020', '1', '1', '1', '2022-09-25 11:19:53', '2022-09-25 11:20:10', '1', '3');
INSERT INTO `blog` VALUES ('VcAHNciAwe', '0', '简介', '10028', 'EasyBlog文档', null, null, '<p data-v-md-line=\"1\">EasyBlog是一个可以生成静态页面的团队博客，可以创建博客，和专题文章。博客可以生成静态页面，可以在线导出所有静态页面，也可以提交到github pagse,gitee pages。<br>\nEasyBlog可以自己平时写博客，还可以邀请志同道合的朋友，同事一起来维护一个博客。</p>\n', 'EasyBlog是一个可以生成静态页面的团队博客，可以创建博客，和专题文章。博客可以生成静态页面，可以在线导出所有静态页面，也可以提交到github pagse,gitee pages。\nEasyBlog可以自己平时写博客，还可以邀请志同道合的朋友，同事一起来维护一个博客。', '1', null, '0', null, '100000', '多多洛2020', '1', '1', '1', '2022-09-25 11:17:33', '2022-09-25 11:18:09', '1', '1');

-- ----------------------------
-- Table structure for blog_category
-- ----------------------------
DROP TABLE IF EXISTS `blog_category`;
CREATE TABLE `blog_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `cover` varchar(100) DEFAULT NULL COMMENT '封面',
  `category_name` varchar(100) DEFAULT NULL COMMENT '分类名称',
  `category_desc` varchar(200) DEFAULT NULL COMMENT '分类描述',
  `category_type` tinyint(4) DEFAULT NULL COMMENT '0:博客分类  1:专题',
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `nick_name` varchar(20) DEFAULT NULL COMMENT '昵称',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10029 DEFAULT CHARSET=utf8mb4 COMMENT='博客分类';

-- ----------------------------
-- Records of blog_category
-- ----------------------------
INSERT INTO `blog_category` VALUES ('10027', null, 'EasyBlog', 'EasyBlog一个可以生成静态页面的博客', '0', null, null, '1');
INSERT INTO `blog_category` VALUES ('10028', null, 'EasyBlog文档', 'EasyBlog文档', '1', '100000', '多多洛2020', '2');

-- ----------------------------
-- Table structure for blog_team_user
-- ----------------------------
DROP TABLE IF EXISTS `blog_team_user`;
CREATE TABLE `blog_team_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `nick_name` varchar(30) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(100) DEFAULT NULL COMMENT '头像',
  `phone` varchar(11) DEFAULT NULL COMMENT '手机号',
  `password` varchar(32) DEFAULT NULL COMMENT '密码',
  `profession` varchar(20) DEFAULT NULL COMMENT '职业',
  `introduction` text COMMENT '简介',
  `editor_type` tinyint(4) DEFAULT NULL COMMENT '0:富文本 1:markdown编辑器',
  `role_type` tinyint(4) DEFAULT NULL COMMENT '0:普通用户 1:超级管理员',
  `status` tinyint(4) DEFAULT NULL COMMENT '0:禁用 1:启用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `idx_key` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=100003 DEFAULT CHARSET=utf8mb4 COMMENT='博客成员';

-- ----------------------------
-- Records of blog_team_user
-- ----------------------------
INSERT INTO `blog_team_user` VALUES ('100000', '多多洛2020', '202209/YXqtWcMXrPkxzkyTJeQjCiATKisguw.gif', '18666666666', '0192023a7bbd73250516f069df18b500', 'Java开发', '<p style=\"text-align: start;\">老程序员一枚，目前就职于武汉某上市互联网公司，主要做Java开发，半拉子前端。之前领导是这么评价我的，在Java组，我前端是最牛逼的，在前端组我Java是最牛逼的。不知道这是夸我还是夸我。</p><p style=\"text-align: start;\"> &nbsp; &nbsp; &nbsp;平时喜欢敲敲代码，喜欢打乒乓球，偶尔游戏（war3，好久没玩了），爱耍抖音（刷完一片空虚，哈哈，有木有同类）。我的座右铭是 搞事情多做要快，姿势要帅。不喜欢加班，也很少加班。</p><p><br></p>', '1', '1', '1', '2021-12-04 20:56:01', '2021-12-23 15:17:12');
INSERT INTO `blog_team_user` VALUES ('100002', '程序员老罗', '202209/dUTIjaablvTKvdyoljYpSCeBHzUguN.jpg', '18766666666', '0192023a7bbd73250516f069df18b500', '程序员', '<p style=\"text-align: start;\">程序员老罗，老程序员一枚</p>', '0', '0', '1', '2022-09-24 18:35:14', null);
