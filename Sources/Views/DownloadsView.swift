import SwiftUI

struct DownloadsView: View {
    @ObservedObject private var store = DownloadStore.shared

    var body: some View {
        NavigationStack {
            Group {
                if store.files.isEmpty {
                    ContentUnavailableView(
                        "暂无下载",
                        systemImage: "arrow.down.circle",
                        description: Text("浏览网页时可从右上角菜单下载当前链接。")
                    )
                } else {
                    List {
                        ForEach(store.files) { file in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(file.name)
                                        .lineLimit(2)
                                    Text(file.modifiedAt, style: .date)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                ShareLink(item: file.url) {
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                        }
                        .onDelete(perform: store.delete)
                    }
                }
            }
            .navigationTitle("下载")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.refresh()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}
