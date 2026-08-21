import Foundation

enum HomeSite: String, CaseIterable, Identifiable {
    case ehentai = "E-Hentai"
    case exhentai = "ExHentai"

    var id: String { rawValue }

    var url: URL {
        switch self {
        case .ehentai:
            return URL(string: "https://e-hentai.org/")!
        case .exhentai:
            return URL(string: "https://exhentai.org/")!
        }
    }
}
