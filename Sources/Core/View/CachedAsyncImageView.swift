import Foundation
import SwiftUI

public struct CachedAsyncImageView<Content: View>: View {
    @State var phase: SwiftUI.AsyncImagePhase = .empty

    let url: URL?
    let urlSession: URLSession
    let scale: CGFloat
    let transaction: Transaction
    let content: (SwiftUI.AsyncImagePhase) -> Content

    public init(url: URL?, urlCache: URLCache = .shared, cachePolicty: NSURLRequest.CachePolicy = .returnCacheDataElseLoad, scale: CGFloat = 1, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (SwiftUI.AsyncImagePhase) -> Content) {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = urlCache
        configuration.requestCachePolicy = cachePolicty

        self.url = url
        self.urlSession = .init(configuration: configuration)
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    public init<I: View, P: View>(url: Foundation.URL?, urlCache: URLCache = .shared, cachePolicty: NSURLRequest.CachePolicy = .returnCacheDataElseLoad, scale: CoreGraphics.CGFloat = 1, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) where Content == _ConditionalContent<I, P> {
        self.init(url: url, urlCache: urlCache, cachePolicty: cachePolicty, scale: scale) { phase in
            if let image = phase.image {
                content(image)
            } else {
                placeholder()
            }
        }
    }

    public var body: some View {
        content(phase)
            .animation(transaction.animation, value: phase.image)
            .task(id: url) {
                await load(url: url)
            }
    }

    struct NetworkError: Error {

    }

    private func load(url: URL?) async {
        guard let url = url else {
            phase = .empty
            return
        }

        do {
            let request = URLRequest(url: url)
            let (data, _) = try await urlSession.data(for: request)
            if let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                phase = .success(image)
            } else {
                throw NetworkError()
            }
        } catch {
            phase = .failure(error)
        }
    }
}

