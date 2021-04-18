import Foundation
import Combine
import PhotosUI
import Photos

enum PhotoLibraryPrepareAction {
    case openSettingApp
    case requestAuthorization
}

enum PhotoLibraryPickedError: LocalizedError {
    case convertError
    
    var localizedDescription: String {
        switch self {
        case .convertError:
            return "画像として認識できませんでした。画像を変えてお試しください"
        }
    }
}

protocol PhotoLibrary {
    func prepareActionType() -> PhotoLibraryPrepareAction?
    func requestAuthorization() -> AnyPublisher<PHAuthorizationStatus, Never>
    func convert(pickerResult: PHPickerResult) -> AnyPublisher<UIImage, Error>
}

fileprivate struct _PhotoLibrary: PhotoLibrary {
    func prepareActionType() -> PhotoLibraryPrepareAction? {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized,  .limited:
            return nil
        case .restricted, .denied:
            return .openSettingApp
        case .notDetermined:
            return .requestAuthorization
        @unknown default:
            assertionFailure("unexpected authorization status \(status):\(status.rawValue)")
            return nil
        }
    }
    
    func requestAuthorization() -> AnyPublisher<PHAuthorizationStatus, Never> {
        Future { promise in
            PHPhotoLibrary.requestAuthorization { (status) in
                promise(.success(status))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func convert(pickerResult: PHPickerResult) -> AnyPublisher<UIImage, Error> {
        Future { promise in
            pickerResult.itemProvider.loadObject(ofClass: UIImage.self) { (itemProviderReading, error) in
                switch (itemProviderReading, error) {
                case (nil, let error?):
                    promise(.failure(error))
                case (let itemProviderReading as UIImage, _):
                    promise(.success(itemProviderReading))
                case _:
                    promise(.failure(PhotoLibraryPickedError.convertError))
                }
            }
        }.eraseToAnyPublisher()
    }
}

let photoLibrary: PhotoLibrary = _PhotoLibrary()
