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
    func upload(jpegData: Data) -> AnyPublisher<Uploaded, Error> {
        var task: StorageUploadTask?
        return Future { promise in
            task = self
                .reference
                .child(generateFileName() + ".jpg")
                .putData(jpegData, metadata: nil) { metadata, error in
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
    public func getData(imagePath: ImagePath) -> AnyPublisher<Data, Error> {
        guard let imagePath = imagePath.imagePath else {
            return Combine.Fail(error: FetchError.imagePathNotFound).eraseToAnyPublisher()
        }
        var task: StorageDownloadTask?
        return Future<Data, Error> {  promise in
            task = self.reference.child(imagePath).getData(maxSize: maximumDataSize) { (data, error) in
                if let error = error {
                    promise(.failure(error))
                }
                guard let data = data else {
                    fatalError("Uh-oh, an error occurred!")
                }
                promise(.success(data))
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
