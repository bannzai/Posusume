import UIKit
import FirebaseStorage
import FirebaseStorageSwift
import Combine

private let maximumDataSize: Int64 = 10 * 1024 * 1024
public struct CloudStorage {
    public static let shared = CloudStorage()
    private init() {}

    public var rootReference: StorageReference { Storage.storage().reference() }
}

// MARK: - asinc/await
extension CloudStorage {
    public enum PathKind {
        case spot(userID: Me.ID, spotID: String)

        var path: String {
            switch self {
            case let .spot(userID, spotID):
                return "users/\(userID.rawValue)/spots/\(spotID)"
            }
        }
    }

    // MARK: - Upload
    public struct Uploaded {
        var url: URL { URL(string: path )! }
        let path: String
    }
    public enum UploadError: Error {
        case convertToJPEG
    }

    public func upload(path: PathKind, imageName: String = UUID().uuidString, image: UIImage) async throws -> Uploaded {
        guard let jpegImage = image.jpegData(compressionQuality: 1) else {
            throw UploadError.convertToJPEG
        }
        let reference = rootReference.child("\(path.path)/\(imageName)")

        return try await withCheckedThrowingContinuation { continuation in
            reference
                .putData(jpegImage, metadata: .init(dictionary: ["contentType": "image/jpeg"])) { result in
                    switch result {
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    case .success:
                        Task {
                            let url: URL
                            do {
                                url = try await reference.downloadURL()
                            } catch {
                                continuation.resume(throwing: error)
                                return
                            }

                            continuation.resume(returning: .init(path: url.absoluteString))
                        }
                    }
                }
        }
    }

    public enum DownloadError: Error {
        case convertToUIImage
    }
    // MARK: - Download
    public func download(path: PathKind) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            rootReference
                .child(path.path)
                .getData(maxSize: maximumDataSize) { (data, error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        guard let _data = data, let image = UIImage(data: _data) else {
                            continuation.resume(throwing: DownloadError.convertToUIImage)
                            return
                        }
                        continuation.resume(returning: image)
                    }
                }
        }
    }
}
