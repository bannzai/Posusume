import Foundation
import Combine
import UIKit

@MainActor
public final class Upload: ObservableObject {
    @Published public private(set) var isProcessing = false
    @Published public private(set) var response: CloudStorage.Uploaded?
    @Published public private(set) var error: Error?

    internal func upload(path: CloudStorage.PathKind, image: UIImage) async {
        isProcessing = true
        defer {
            isProcessing = false
        }

        do {
            response = try await CloudStorage.shared.upload(path: path, image: image)
        } catch {
            self.error = error
        }
    }

    public func callAsFunction(path: CloudStorage.PathKind, image: UIImage) async {
        await upload(path: path, image: image)
    }
}
