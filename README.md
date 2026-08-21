# EhViewer iOS Prototype v0.1

这是一个面向 iPhone 的 **EhViewer iOS 第一阶段原型工程**。

它不是 APK 转 IPA，也不是 Android 版完整功能的伪装版本。当前版本先解决 iOS 端可运行、可登录、可浏览、可收藏、可下载和可加锁的问题，并提供 GitHub Actions 自动生成未签名 IPA。

## 已完成

- iOS 16+ / iPhone
- SwiftUI 原生外壳
- 内置 WKWebView
- E-Hentai / ExHentai 快速切换
- WKWebView 默认持久化 Cookie，可用于网页登录状态
- 前进 / 后退 / 刷新 / 首页
- 收藏当前页面
- 下载当前 HTTP/HTTPS 链接到 App Documents
- 下载文件列表与系统分享
- Face ID / 设备密码应用锁
- 深色 / 浅色 / 跟随系统
- 一键清除网页 Cookie 和缓存
- GitHub Actions 自动构建 unsigned IPA

## 尚未完成

以下属于完整 EhViewer 原生移植的第二阶段：

- 原生 E-Hentai 画廊列表解析
- 原生标签与高级搜索 UI
- ExHentai 账号状态/API 适配
- EhViewer Android 收藏数据库兼容
- 原生图片阅读器与预加载
- 多线程画廊下载
- 下载任务断点续传
- EhViewer 设置项完整迁移
- Compose Multiplatform 核心代码接入
- Android/iOS 双平台共享业务层

## Windows 用户如何生成 IPA

### 方案 A：GitHub Actions

1. 在 GitHub 新建一个仓库。
2. 将本压缩包内的所有文件上传到仓库根目录。
3. 打开仓库的 **Actions**。
4. 选择 **Build unsigned IPA**。
5. 点击 **Run workflow**。
6. 构建完成后下载 Artifact：`EhViewerIOS-unsigned`。
7. 解压后得到 `EhViewerIOS-unsigned.ipa`。
8. Windows 使用 Sideloadly 选择该 IPA，用自己的 Apple Account 签名安装。

GitHub Actions 使用 macOS 编译机，所以 Windows 本地不需要安装 Xcode。

## Mac 用户本地编译

需要：

- Xcode
- XcodeGen

```bash
brew install xcodegen
xcodegen generate
open EhViewerIOS.xcodeproj
```

在 Xcode 中选择自己的 Team 后即可真机运行。

## 登录说明

浏览页直接打开 E-Hentai / ExHentai 网站。网页登录成功后，Cookie 由 `WKWebsiteDataStore.default()` 保存。

如果 ExHentai 仍显示空白/权限页，一般意味着账号本身尚未获得 ExHentai 权限，不是客户端能绕过的问题。

## 下载说明

v0.1 的“下载当前链接”是基础下载能力。如果当前 URL 是图片或文件地址，会直接保存；如果当前 URL 是普通 HTML 页面，则保存的可能是网页响应。

完整 EhViewer 式画廊批量下载将在第二阶段通过原生页面解析实现。

## 上游项目

设计目标参考：

- FooIbar/EhViewer
- https://github.com/FooIbar/EhViewer

上游项目使用 GPL-3.0。若后续直接整合或修改上游 GPL 代码并发布，应继续遵守对应许可证要求。

## 版本

Prototype v0.1
