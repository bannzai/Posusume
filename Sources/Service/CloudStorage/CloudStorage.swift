import UIKit
import FirebaseStorage
import FirebaseStorageSwift
import Combine

private let maximumDataSize: Int64 = 10 * 1024 * 1024
public struct CloudStorage {
    public static let shared = CloudStorage()
    private init() {}

    public let reference: StorageReference = Storage.storage().reference()
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
        case cloudStoragePathNotFound
    }

    public func upload(path: PathKind, image: UIImage) async throws -> Uploaded {
        guard let jpegImage = image.jpegData(compressionQuality: 1) else {
            throw UploadError.convertToJPEG
        }

        return try await withCheckedThrowingContinuation { continuation in
            reference
                .child(path.path)
                .putData(jpegImage, metadata: .init(dictionary: ["Content-Type": "image/jpeg"])) { result in
                    switch result {
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    case let .success(metadata):
                        guard let path = metadata.path else {
                            continuation.resume(throwing: UploadError.cloudStoragePathNotFound)
                            return
                        }
                        continuation.resume(returning: .init(path: path))
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
            reference
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
