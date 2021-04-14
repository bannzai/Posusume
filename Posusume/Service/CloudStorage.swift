import UIKit
import FirebaseStorage
import Combine

private let maximumDataSize: Int64 = 10 * 1024 * 1024
struct CloudStorage {
    let _reference: StorageReference = Storage.storage().reference()
    func reference(paths: [String]) -> StorageReference {
        var reference = _reference
        paths.forEach {
            reference = reference.child($0)
        }
        return reference
    }

    private func generateJPEGFileName() -> String {
        UUID().uuidString + ".jpg"
    }
    
    // MARK: - Upload
    struct Uploaded {
        let path: String
    }
    enum UploadError: Error {
        case convertToJPEG
    }
    func upload<T: CloudStorageImageFileName>(path: CloudStoragePathBuilder<T>, image: UIImage, imageFileName: T?) -> AnyPublisher<Uploaded, Error> {
        guard let jpegImage = image.jpegData(compressionQuality: 1) else {
            return Combine.Fail(error: UploadError.convertToJPEG).eraseToAnyPublisher()
        }
        var task: StorageUploadTask?
        return Future { promise in
            task = self
                .reference(paths: path.paths)
                .child(imageFileName?.imageFileName ?? generateJPEGFileName())
                .putData(jpegImage, metadata: nil) { metadata, error in
                    if let error = error {
                        return promise(.failure(error))
                    }
                    guard let _metadata = metadata, let path = _metadata.path else {
                        fatalError("path not found in cloud storage response metadata \(String(describing: metadata))")
                    }
                    promise(.success(.init(path: path)))
                }
        }.handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
    }
    
    
    // MARK: - Fetch
    public func fetch<T: CloudStorageImageFileName>(path: CloudStoragePathBuilder<T>, imageFileName: T) -> AnyPublisher<UIImage, Error> {
        var task: StorageDownloadTask?
        return Future { promise in
            task = self
                .reference(paths: path.paths)
                .child(imageFileName.imageFileName)
                .getData(maxSize: maximumDataSize) { (data, error) in
                    if let error = error {
                        promise(.failure(error))
                    }
                    guard let _data = data, let image = UIImage(data: _data) else {
                        fatalError("data cann't convert to UIImage. data: \(String(describing: data))")
                    }
                    promise(.success(image))
                }
        }.handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
        
    }
}
