import Foundation
import UIKit
import SwiftUI
import PhotosUI
import Photos
import Combine

struct PhotoLibraryView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss

    let photoLibrary: PhotoLibrary

    @Binding var photoLibraryResult: PhotoLibraryResult?
    @Binding var error: Error?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: sharedPhotoLibraryConfiguration)
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
                parent.dismiss()
                return
            }
            canceller?.cancel()
            canceller = parent.photoLibrary.convert(pickerResult: result)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    defer {
                        self?.parent.dismiss()
                    }

                    switch completion {
                    case .failure(let error):
                        self?.parent.error = error
                    case .finished:
                        return
                    }
                }, receiveValue: { [weak self] (result) in
                    self?.parent.photoLibraryResult = result
                })
        }
    }
}

struct PhotoLibraryView_Previews: PreviewProvider {
    @State static var photoLibraryResult: PhotoLibraryResult? = nil
    @State static var error: Error? = nil

    static var previews: some View {
        PhotoLibraryView(
            photoLibrary: MockPhotoLibrary(),
            photoLibraryResult: $photoLibraryResult,
            error: $error
        )
    }
}
