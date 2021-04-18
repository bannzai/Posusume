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
    case selected([PHPickerResult])
    case converted(Result<PhotoLibraryResult, EquatableError>)
    case end(PhotoLibraryResult)
}

struct PhotoLibraryEnvironment {
    let me: Me
    let photoLibrary: PhotoLibrary
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

let reducer: Reducer<PhotoLibraryState, PhotoLibraryAction, PhotoLibraryEnvironment> = .init { state, action, environment in
    switch action {
    case let .selected(selectedResults):
        guard let selected = selectedResults.first else {
            fatalError("unexpected selectedResult is empty")
        }
        return environment
            .photoLibrary
            .convert(pickerResult: selected)
            .mapError(EquatableError.init(error:))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(PhotoLibraryAction.converted)
    case let .converted(.success(result)):
        return Effect(value: .end(result))
    case let .converted(.failure(error)):
        state.error = error
        return .none
    case .end:
        return .none
    }
}

private let sharedPhotoLibraryConfiguration: PHPickerConfiguration = .init(photoLibrary: PHPhotoLibrary.shared())

struct PhotoLibraryView: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration = sharedPhotoLibraryConfiguration
    let photoLibrary: PhotoLibrary
    @Binding var result: PhotoLibraryResult
    @Binding var error: Error
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
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
                .sink(receiveCompletion: { [weak self] (completion) in
                    switch completion {
                    case .failure(let error):
                        self?.parent.error = error
                    case .finished:
                        return
                    }
                }, receiveValue: { [weak self] result in
                    self?.parent.result = result
                })
        }
    }
}

struct PhotoLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoLibraryView(
            photoLibrary: MockPhotoLibrary(),
            result: .init(get: { .init(image: .init(), location: nil, takeDate: nil) }, set: { _ in }),
            error: .init(get: { NSError(domain: "error.bannzai.posusume", code: 999, userInfo: nil) }, set: { _ in }),
            isPresented: .init(get: { false }, set: { _ in })
        )
    }
}
