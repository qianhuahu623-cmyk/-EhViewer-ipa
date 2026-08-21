import SwiftUI

struct BrowserTab: View {
    @StateObject private var session = BrowserSession()
    @ObservedObject private var favorites = FavoritesStore.shared
    @ObservedObject private var downloads = DownloadStore.shared

    @AppStorage("homeSite") private var homeSite = HomeSite.ehentai.rawValue
    @State private var showSiteMenu = false
    @State private var showDownloadStatus = false

    private var selectedSite: HomeSite {
        HomeSite(rawValue: homeSite) ?? .ehentai
    }

    var body: some View {
        NavigationStack {
            WebView(session: session, initialURL: selectedSite.url)
                .ignoresSafeArea(edges: .bottom)
                .navigationTitle(session.pageTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            if let url = session.currentURL {
                                favorites.add(title: session.pageTitle, url: url)
                            }
                        } label: {
                            Image(systemName: "star")
                        }
                        .disabled(session.currentURL == nil)

                        Menu {
                            Button("E-Hentai") {
                                homeSite = HomeSite.ehentai.rawValue
                                session.load(HomeSite.ehentai.url)
                            }
                            Button("ExHentai") {
                                homeSite = HomeSite.exhentai.rawValue
                                session.load(HomeSite.exhentai.url)
                            }
                            Divider()
                            Button("下载当前链接") {
                                guard let url = session.currentURL else { return }
                                Task {
                                    await downloads.download(url)
                                    showDownloadStatus = true
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    browserBar
                }
                .alert("下载", isPresented: $showDownloadStatus) {
                    Button("好", role: .cancel) {}
                } message: {
                    Text(downloads.statusText ?? "完成")
                }
        }
    }

    private var browserBar: some View {
        HStack(spacing: 24) {
            Button {
                session.goBack()
            } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(!session.canGoBack)

            Button {
                session.goForward()
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(!session.canGoForward)

            Spacer()

            Text(session.currentURL?.host ?? selectedSite.rawValue)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Spacer()

            Button {
                if session.isLoading {
                    session.stop()
                } else {
                    session.reload()
                }
            } label: {
                Image(systemName: session.isLoading ? "xmark" : "arrow.clockwise")
            }

            Button {
                session.load(selectedSite.url)
            } label: {
                Image(systemName: "house")
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(.regularMaterial)
    }
}
