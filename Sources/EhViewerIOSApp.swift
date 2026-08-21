import SwiftUI

@main
struct EhViewerIOSApp: App {
    @AppStorage("appearance") private var appearance = "system"

    private var colorScheme: ColorScheme? {
        switch appearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(colorScheme)
        }
    }
}
