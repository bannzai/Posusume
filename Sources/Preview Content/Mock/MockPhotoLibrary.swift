import PhotosUI
import Photos
import Combine

#if DEBUG
struct MockPhotoLibrary: PhotoLibrary {
    func prepareActionType() -> PhotoLibraryPrepareAction? { nil }
    func requestAuthorization() -> AnyPublisher<PHAuthorizationStatus, Never> { Future(value: .authorized).eraseToAnyPublisher() }
    func convert(pickerResult: PHPickerResult) -> AnyPublisher<PhotoLibraryResult, Error> { Future(value: PhotoLibraryResult(image: UIImage(named: "hanahana")!, location: nil, takeDate: nil)).eraseToAnyPublisher() }
}
#endif
