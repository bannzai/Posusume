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
    @State var phase: SwiftUI.AsyncImagePhase

    let url: URL?
    let scale: CGFloat
    let transaction: Transaction
    let content: (SwiftUI.AsyncImagePhase) -> Content

    // Use on network request or cache key
    static func request(url: URL) -> URLRequest {
        .init(url: url)
    }

    public init(url: URL?, scale: CGFloat = 1, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (SwiftUI.AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content

        let phase: SwiftUI.AsyncImagePhase = {
            guard let url = url else {
                return .empty
            }

            if let cachedResponse = urlSession.configuration.urlCache?.cachedResponse(for: Self.request(url: url)) {
                if let uiImage = UIImage(data: cachedResponse.data) {
                    return .success(Image(uiImage: uiImage))
                }
            }
            return .empty
        }()
        self._phase = .init(initialValue: phase)
    }

    public init<I: View, P: View>(url: Foundation.URL?, scale: CoreGraphics.CGFloat = 1, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) where Content == _ConditionalContent<I, P> {
        self.init(url: url, scale: scale) { phase in
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

        let request = Self.request(url: url)
        do {
            let (data, _) = try await urlSession.data(for: request)
            if let uiImage = UIImage(data: data) {
                phase = .success(Image(uiImage: uiImage))
            } else {
                throw NetworkError()
            }
        } catch {
            phase = .failure(error)
        }
    }
}

