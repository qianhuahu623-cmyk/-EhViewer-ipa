import Foundation
import Combine
import WebKit

@MainActor
final class BrowserSession: NSObject, ObservableObject {
    @Published var currentURL: URL?
    @Published var pageTitle: String = "EhViewer"
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var isLoading = false

    weak var webView: WKWebView?

    func attach(_ webView: WKWebView) {
        self.webView = webView
        sync(from: webView)
    }

    func load(_ url: URL) {
        webView?.load(URLRequest(url: url))
    }

    func goBack() {
        webView?.goBack()
    }

    func goForward() {
        webView?.goForward()
    }

    func reload() {
        webView?.reload()
    }

    func stop() {
        webView?.stopLoading()
    }

    func sync(from webView: WKWebView) {
        currentURL = webView.url
        pageTitle = webView.title ?? currentURL?.host ?? "EhViewer"
        canGoBack = webView.canGoBack
        canGoForward = webView.canGoForward
        isLoading = webView.isLoading
    }
}
