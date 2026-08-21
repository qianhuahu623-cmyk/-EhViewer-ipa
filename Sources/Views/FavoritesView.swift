import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var store = FavoritesStore.shared

    var body: some View {
        NavigationStack {
            Group {
                if store.items.isEmpty {
                    EmptyFavoritesView()
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

private struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "star")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)

            Text("暂无收藏")
                .font(.headline)

            Text("在浏览页面点击右上角星标保存当前页面。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
