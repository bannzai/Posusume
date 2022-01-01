import Foundation
import SwiftUI

// For example, SwiftUI.Map recreates AsyncImage every time it zooms. Therefore, instead of having a URLSession in the View, we'll make it common and make it easier to cache.
private var urlSession: URLSession = {
    // URLCache.shared memoryCapacity 4MB, diskCapacity: 20MB in document. But actually memoryCapacity 512KB, diskCapacity: 10MB
    // Posusume loads a lot of images, so it is increasing the capacity
    let configuration = URLSessionConfiguration.default
    configuration.urlCache = .init(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, directory: nil)
    configuration.requestCachePolicy = .returnCacheDataElseLoad

    return .init(configuration: configuration)
}()

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

