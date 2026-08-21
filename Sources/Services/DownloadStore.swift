import Foundation

struct DownloadedFile: Identifiable, Hashable {
    let url: URL
    let modifiedAt: Date

    var id: URL { url }
    var name: String { url.lastPathComponent }
}

@MainActor
final class DownloadStore: ObservableObject {
    static let shared = DownloadStore()

    @Published private(set) var files: [DownloadedFile] = []
    @Published var statusText: String?
    @Published var isDownloading = false

    private init() {
        refresh()
    }

    private var downloadDirectory: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = documents.appendingPathComponent("EhViewerDownloads", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    func refresh() {
        let fm = FileManager.default
        let keys: Set<URLResourceKey> = [.contentModificationDateKey, .isRegularFileKey]
        let urls = (try? fm.contentsOfDirectory(
            at: downloadDirectory,
            includingPropertiesForKeys: Array(keys),
            options: [.skipsHiddenFiles]
        )) ?? []

        files = urls.compactMap { url in
            let values = try? url.resourceValues(forKeys: keys)
            guard values?.isRegularFile == true else { return nil }
            return DownloadedFile(
                url: url,
                modifiedAt: values?.contentModificationDate ?? .distantPast
            )
        }
        .sorted { $0.modifiedAt > $1.modifiedAt }
    }

    func download(_ url: URL) async {
        guard ["http", "https"].contains(url.scheme?.lowercased() ?? "") else {
            statusText = "当前链接不是可下载的 HTTP/HTTPS 地址。"
            return
        }

        isDownloading = true
        statusText = "正在下载…"
        defer { isDownloading = false }

        do {
            let (temporaryURL, response) = try await URLSession.shared.download(from: url)
            var name = response.suggestedFilename
            if name == nil || name?.isEmpty == true {
                name = url.lastPathComponent.isEmpty ? "download-\(Int(Date().timeIntervalSince1970))" : url.lastPathComponent
            }

            let destination = uniqueDestination(named: name!)
            try FileManager.default.moveItem(at: temporaryURL, to: destination)
            statusText = "已保存：\(destination.lastPathComponent)"
            refresh()
        } catch {
            statusText = "下载失败：\(error.localizedDescription)"
        }
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            try? FileManager.default.removeItem(at: files[index].url)
        }
        refresh()
    }

    private func uniqueDestination(named rawName: String) -> URL {
        let safe = rawName.replacingOccurrences(of: "/", with: "_")
        let ext = (safe as NSString).pathExtension
        let base = (safe as NSString).deletingPathExtension
        var candidate = downloadDirectory.appendingPathComponent(safe)
        var index = 2

        while FileManager.default.fileExists(atPath: candidate.path) {
            let nextName = ext.isEmpty ? "\(base)-\(index)" : "\(base)-\(index).\(ext)"
            candidate = downloadDirectory.appendingPathComponent(nextName)
            index += 1
        }
        return candidate
    }
}
