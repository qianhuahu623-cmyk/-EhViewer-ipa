import Foundation

struct FavoriteItem: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let url: URL
    let createdAt: Date

    init(id: UUID = UUID(), title: String, url: URL, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.url = url
        self.createdAt = createdAt
    }
}
