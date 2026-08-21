import Foundation
import LocalAuthentication

enum BiometricLock {
    static func authenticate() async -> Bool {
        let context = LAContext()
        context.localizedCancelTitle = "取消"

        var error: NSError?
        let policy: LAPolicy = .deviceOwnerAuthentication

        guard context.canEvaluatePolicy(policy, error: &error) else {
            return false
        }

        do {
            return try await context.evaluatePolicy(
                policy,
                localizedReason: "解锁 EhViewer iOS"
            )
        } catch {
            return false
        }
    }
}
