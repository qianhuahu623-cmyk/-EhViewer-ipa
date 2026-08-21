import SwiftUI

struct LockView: View {
    let onUnlocked: () -> Void

    @State private var message = "需要验证身份"

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "faceid")
                .font(.system(size: 64))

            Text("EhViewer iOS 已锁定")
                .font(.title2.bold())

            Text(message)
                .foregroundStyle(.secondary)

            Button("使用 Face ID / 密码解锁") {
                authenticate()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(30)
        .task {
            authenticate()
        }
    }

    private func authenticate() {
        Task {
            if await BiometricLock.authenticate() {
                onUnlocked()
            } else {
                message = "验证失败，可以再次尝试。"
            }
        }
    }
}
