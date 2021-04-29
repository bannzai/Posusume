import Foundation
import UIKit
import SwiftUI
import ComposableArchitecture
import Combine
import CoreLocation

struct PhotoCameraCaptureResult: Equatable {
    let image: UIImage
    let location: CLLocationCoordinate2D
}

struct PhotoCameraState: Equatable {
    var result: PhotoCameraCaptureResult?
    var error: EquatableError?
}

enum PhotoCameraAction: Equatable {
    case captured(UIImage)
    case dismiss
}

struct PhotoCameraEnvironment {
    let me: Me
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

let PhotoCameraReducer: Reducer<PhotoCameraState, PhotoCameraAction, PhotoCameraEnvironment> = .init { state, action, environment in
    switch action {
    case let .captured(image):
        return Effect(value: .dismiss)
    case .dismiss:
        return .none
    }
}

struct PhotoCameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    @Environment(\.presentationMode) private var presentationMode
    let captured: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIImagePickerController()
        viewController.allowsEditing = false
        viewController.sourceType = .camera
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: PhotoCameraView
        
        init(parent: PhotoCameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                parent.presentationMode.wrappedValue.dismiss()
                return
            }
            parent.captured(image)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct PhotoCameraViewConnector: View {
    let store: Store<PhotoCameraState, PhotoCameraAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            PhotoCameraView(
                captured: { value in
                    viewStore.send(.captured(value))
                }
            )
        }
    }
}

struct PhotoCameraView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCameraView(
            captured: { _ in
                
            }
        )
    }
}
