import Foundation
import SwiftUI

@MainActor
final class FavoritesStore: ObservableObject {
    static let shared = FavoritesStore()

    @Published private(set) var items: [FavoriteItem] = []
    private let key = "ehviewer_ios_favorites"

    private init() {
        load()
    }

    func add(title: String, url: URL) {
        if items.contains(where: { $0.url == url }) {
            return
        }
        items.insert(FavoriteItem(title: title.isEmpty ? url.absoluteString : title, url: url), at: 0)
        save()
    }

    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let decoded = try? JSONDecoder().decode([FavoriteItem].self, from: data)
        else { return }
        items = decoded
    }
}
