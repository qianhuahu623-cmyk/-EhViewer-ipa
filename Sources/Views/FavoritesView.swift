import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var store = FavoritesStore.shared

    var body: some View {
        NavigationStack {
            Group {
                if store.items.isEmpty {
                    ContentUnavailableView(
                        "暂无收藏",
                        systemImage: "star",
                        description: Text("在浏览页面点击右上角星标保存当前页面。")
                    )
                } else {
                    List {
                        ForEach(store.items) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.title)
                                    .font(.headline)
                                    .lineLimit(2)

                                Text(item.url.absoluteString)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)

                                HStack {
                                    Link(destination: item.url) {
                                        Label("打开", systemImage: "safari")
                                    }

                                    Spacer()

                                    ShareLink(item: item.url) {
                                        Label("分享", systemImage: "square.and.arrow.up")
                                    }
                                }
                                .font(.caption)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: store.remove)
                    }
                }
            }
            .navigationTitle("收藏")
        }
    }
}
