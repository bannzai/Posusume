import UIKit
import FirebaseStorage
import Combine

private let maximumDataSize: Int64 = 10 * 1024 * 1024
struct CloudStorage {
    let reference: StorageReference
    init(path: CloudStoragePathBuilder) {
        var reference = Storage.storage().reference()
        path.paths.forEach {
            reference = reference.child($0)
        }
        self.reference = reference
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
    func upload(image: UIImage, imageName: String?) -> AnyPublisher<Uploaded, Error> {
        guard let jpegImage = image.jpegData(compressionQuality: 1) else {
            return Combine.Fail(error: UploadError.convertToJPEG).eraseToAnyPublisher()
        }
        var task: StorageUploadTask?
        return Future { promise in
            task = self
                .reference
                .child(imageName ?? generateJPEGFileName())
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
    public func fetch(imageName: String) -> AnyPublisher<UIImage, Error> {
        var task: StorageDownloadTask?
        return Future { promise in
            task = self.reference.child(imageName).getData(maxSize: maximumDataSize) { (data, error) in
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
