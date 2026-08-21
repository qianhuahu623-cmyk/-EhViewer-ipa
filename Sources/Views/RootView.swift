import SwiftUI

struct RootView: View {
    @AppStorage("faceIDEnabled") private var faceIDEnabled = false
    @State private var locked = false

    var body: some View {
        Group {
            if locked {
                LockView {
                    locked = false
                }
            } else {
                MainTabs()
            }
        }
        .onAppear {
            locked = faceIDEnabled
        }
    }
}

private struct MainTabs: View {
    var body: some View {
        TabView {
            BrowserTab()
                .tabItem {
                    Label("浏览", systemImage: "safari")
                }

            FavoritesView()
                .tabItem {
                    Label("收藏", systemImage: "star")
                }

            DownloadsView()
                .tabItem {
                    Label("下载", systemImage: "arrow.down.circle")
                }

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape")
                }
        }
    }
}
