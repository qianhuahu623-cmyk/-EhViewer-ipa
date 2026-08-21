# 完整 iOS 移植下一阶段

上游 EhViewer 已存在 `core:common`、`core:data`、`core:ui` 等 Kotlin Multiplatform 结构，但当前构建逻辑仍只真正配置 Android target。

完整双平台迁移建议：

1. 在 KMP convention plugin 中增加 `iosArm64()` 与 `iosSimulatorArm64()`。
2. 给 KMP shared modules 建立 `iosMain`。
3. Ktor Android 使用 OkHttp engine，iOS 使用 Darwin engine。
4. Android-only API 迁移到 expect/actual：
   - Context
   - WorkManager
   - Android Biometric
   - Android WebView
   - Android filesystem
5. Room 数据库确认 iOS target 和 KSP task 后再接入。
6. UI 逐步从 Android `app` 下移到共享 Compose module。
7. iOS 入口可先 SwiftUI 包装 ComposeUIViewController，再逐步减少 Swift 壳。
8. 最终 GitHub Actions 生成 unsigned IPA，由 Sideloadly/AltStore 签名。

v0.1 原型故意不直接修改上游仓库，以免在 Android-only 依赖还没拆干净时造成大量不可编译改动。
