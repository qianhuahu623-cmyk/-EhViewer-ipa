import SwiftUI
import WebKit

struct SettingsView: View {
    @AppStorage("homeSite") private var homeSite = HomeSite.ehentai.rawValue
    @AppStorage("faceIDEnabled") private var faceIDEnabled = false
    @AppStorage("appearance") private var appearance = "system"

    @State private var showClearConfirmation = false
    @State private var clearResult = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("浏览") {
                    Picker("默认站点", selection: $homeSite) {
                        ForEach(HomeSite.allCases) { site in
                            Text(site.rawValue).tag(site.rawValue)
                        }
                    }

                    Button("清除网页 Cookie 与缓存", role: .destructive) {
                        showClearConfirmation = true
                    }

                    if !clearResult.isEmpty {
                        Text(clearResult)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("隐私") {
                    Toggle("启动时使用 Face ID / 密码锁", isOn: $faceIDEnabled)
                }

                Section("外观") {
                    Picker("主题", selection: $appearance) {
                        Text("跟随系统").tag("system")
                        Text("浅色").tag("light")
                        Text("深色").tag("dark")
                    }
                }

                Section("关于") {
                    LabeledContent("版本", value: "0.1 原型")
                    Text("这是 EhViewer iOS 移植第一阶段的可编译原型。网页浏览、登录 Cookie、收藏、下载与应用锁可用；Android EhViewer 的原生画廊解析、标签数据库与完整阅读器尚未移植。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("设置")
            .confirmationDialog(
                "清除所有网页数据？",
                isPresented: $showClearConfirmation,
                titleVisibility: .visible
            ) {
                Button("清除", role: .destructive) {
                    clearWebData()
                }
                Button("取消", role: .cancel) {}
            }
        }
    }

    private func clearWebData() {
        let store = WKWebsiteDataStore.default()
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        store.fetchDataRecords(ofTypes: types) { records in
            store.removeData(ofTypes: types, for: records) {
                DispatchQueue.main.async {
                    clearResult = "网页 Cookie 与缓存已清除。"
                }
            }
        }
    }
}
