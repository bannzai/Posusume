import Foundation
import UIKit
import SwiftUI
import Combine
import CoreLocation

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

struct PhotoCameraView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCameraView(
            captured: { _ in
                
            }
        )
    }
}
