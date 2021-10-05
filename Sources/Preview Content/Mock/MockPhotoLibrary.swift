import PhotosUI
import Photos
import Combine

#if DEBUG
struct MockPhotoLibrary: PhotoLibrary {
    func prepareActionType() -> PhotoLibraryPrepareAction? { nil }
    func requestAuthorization() async -> PHAuthorizationStatus { .authorized }
    func convert(pickerResult: PHPickerResult) -> AnyPublisher<PhotoLibraryResult, Error> { Future(value: PhotoLibraryResult(image: UIImage(named: "hanahana")!, location: nil, takeDate: nil)).eraseToAnyPublisher() }
}
#endif
