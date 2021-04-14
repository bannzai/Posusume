import UIKit
import FirebaseStorage
import Combine

private let maximumDataSize: Int64 = 10 * 1024 * 1024
struct CloudStorage {
    let reference: StorageReference
    init(userID: UserID) {
        reference = Storage.storage().reference().child("users").child(userID.rawValue)
    }

    private func generateFileName() -> String {
        UUID().uuidString
    }
    
    // MARK: - Upload
    struct Uploaded {
        let path: String
    }
    enum UploadError: Error {
        case convertToJpeg
    }
    func upload(image: UIImage) -> AnyPublisher<Uploaded, Error> {
        guard let jpegImage = image.jpegData(compressionQuality: 1) else {
            return Combine.Fail(error: UploadError.convertToJpeg).eraseToAnyPublisher()
        }
        var task: StorageUploadTask?
        return Future { promise in
            task = self
                .reference
                .child(generateFileName() + ".jpg")
                .putData(jpegImage, metadata: nil) { metadata, error in
                    if let error = error {
                        return promise(.failure(error))
                    }
                    guard let metadata = metadata, let path = metadata.path else {
                        fatalError("Uh-oh, an error occurred!")
                    }
                    promise(.success(.init(path: path)))
                }
        }.handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
    }
    
    
    // MARK: - Fetch
    enum FetchError: Error {
        case imagePathNotFound
    }
    public func fetch(imagePath: ImagePath) -> AnyPublisher<UIImage, Error> {
        guard let imagePath = imagePath.imagePath else {
            return Combine.Fail(error: FetchError.imagePathNotFound).eraseToAnyPublisher()
        }
        var task: StorageDownloadTask?
        return Future { promise in
            task = self.reference.child(imagePath).getData(maxSize: maximumDataSize) { (data, error) in
                if let error = error {
                    promise(.failure(error))
                }
                guard let data = data, let image = UIImage(data: data) else {
                    fatalError("Uh-oh, an error occurred!")
                }
                promise(.success(image))
            }
        }.handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
        
    }
}

protocol ImagePath {
    var imagePath: String? { get }
}
