import Foundation
import UIKit
import SwiftUI
import PhotosUI
import Photos
import ComposableArchitecture
import Combine

struct PhotoLibraryState: Equatable {
    var selectedImage: UIImage?
    var error: EquatableError?
}

enum PhotoLibraryAction: Equatable {
    case selected(PhotoLibraryResult)
    case selectError(EquatableError)
    case end(PhotoLibraryResult)
}

struct PhotoLibraryEnvironment {
    let me: Me
    let photoLibrary: PhotoLibrary
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let pickerConfiguration: PHPickerConfiguration
}

let reducer: Reducer<PhotoLibraryState, PhotoLibraryAction, PhotoLibraryEnvironment> = .init { state, action, environment in
    switch action {
    case let .selected(selectedResult):
        return Effect(value: .end(selectedResult))
    case let .selectError(error):
        state.error = error
        return .none
    case .end:
        return .none
    }
}

struct PhotoLibraryView: UIViewControllerRepresentable {
    let pickerConfiguration: PHPickerConfiguration
    let photoLibrary: PhotoLibrary
    let success: (PhotoLibraryResult) -> Void
    let failure: (Error) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: pickerConfiguration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let parent: PhotoLibraryView
        var canceller: AnyCancellable? = nil
        init(parent: PhotoLibraryView) {
            self.parent = parent
        }
        deinit {
            canceller?.cancel()
            canceller = nil
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let result = results.first else {
                return
            }
            canceller?.cancel()
            canceller = parent.photoLibrary.convert(pickerResult: result)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.parent.failure(error)
                    case .finished:
                        return
                    }
                }, receiveValue: { [weak self] (result) in
                    self?.parent.success(result)
                })
        }
    }
}

struct PhotoLibraryViewConnector: View {
    let store: Store<PhotoLibraryState, PhotoLibraryAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            PhotoLibraryView(
                pickerConfiguration: sharedPhotoLibraryConfiguration,
                photoLibrary: photoLibrary,
                success: { value in
                    viewStore.send(.selected(value))
                },
                failure: { error in
                    viewStore.send(.selectError(.init(error: error)))
                }
            )
        }
    }
}

struct PhotoLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoLibraryView(
            pickerConfiguration: sharedPhotoLibraryConfiguration,
            photoLibrary: MockPhotoLibrary(),
            success: { value in
                
            },
            failure: { error in
                
            }
        )
    }
}
