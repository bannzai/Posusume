import UIKit
import FirebaseStorage

private let maximumDataSize: Int64 = 10 * 1024 * 1024
struct UserContentRemoteStorage {
    let reference: StorageReference
    init(userID: UserID) {
        reference = Storage.storage().reference().child("users").child(userID.rawValue)
    }

    private func generateFileName() -> String {
        UUID().uuidString
    }
    func upload(image: UIImage, closure: @escaping (Result<String, Swift.Error>) -> Void) {
        _ = reference
            .child(generateFileName() + ".jpg")
            .putData(image.jpegData(compressionQuality: 1)!, metadata: nil) { (metadata, error) in
                if let error = error {
                    closure(.failure(error))
                    return
                }
                guard let path = metadata?.path else {
                    fatalError("Uh-oh, an error occurred!")
                }
                closure(.success(path))
            }
    }
    
    func fetch(path: ImagePath, closure: @escaping (UIImage?) -> Void) {
        guard let imagePath = path.imagePath else {
            return
        }
        reference.child(imagePath).getData(maxSize: maximumDataSize) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    if let image = data.map(UIImage.init(data:)) {
                        closure(image)
                    }
                }
            }
        }
    }
}

protocol ImagePath {
    var imagePath: String? { get }
}
