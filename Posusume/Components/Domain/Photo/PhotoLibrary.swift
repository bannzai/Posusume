import Foundation
import Combine
import PhotosUI
import Photos
import CoreLocation

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

struct PhotoLibraryResult: Equatable {
    let image: UIImage
    let location: CLLocationCoordinate2D?
    let takeDate: Date?
}

protocol PhotoLibrary {
    func prepareActionType() -> PhotoLibraryPrepareAction?
    func requestAuthorization() -> AnyPublisher<PHAuthorizationStatus, Never>
    func convert(pickerResult: PHPickerResult) -> AnyPublisher<PhotoLibraryResult, Error>
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
    
    func convert(pickerResult: PHPickerResult) -> AnyPublisher<PhotoLibraryResult, Error> {
        let info: (location: CLLocationCoordinate2D, takeDate: Date)? = {
            if let identifier = pickerResult.assetIdentifier {
                if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject {
                    if let location = asset.location, let takeDate = asset.creationDate {
                        return (location: location.coordinate, takeDate: takeDate)
                    }
                }
            }
            return nil
        }()
        return Future { promise in
            pickerResult.itemProvider.loadObject(ofClass: UIImage.self) { (itemProviderReading, error) in
                switch (itemProviderReading, error) {
                case (nil, let error?):
                    promise(.failure(error))
                case (let image as UIImage, _):
                    promise(.success(.init(image: image, location: info?.location, takeDate: info?.takeDate)))
                case _:
                    promise(.failure(PhotoLibraryPickedError.convertError))
                }
            }
        }.eraseToAnyPublisher()
    }
}

let photoLibrary: PhotoLibrary = _PhotoLibrary()
