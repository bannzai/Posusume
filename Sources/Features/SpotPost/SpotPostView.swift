import SwiftUI
import Combine
import CoreLocation
import PhotosUI
import Photos
import MapKit
import FirebaseStorageSwift

struct SpotPostView: View {
    @Environment(\.locationManager) var locationManager
    @Environment(\.geocoder) var geocoder
    @Environment(\.dismiss) private var dismiss

    @State var error: Error?
    @State var title: String = ""
    @State var image: UIImage?
    @State var placemark: Placemark?
    @State var editorState: SpotPostEditorPageState = .init()
    @State var editingSnapshot: UIImage?

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        SpotPostImage(
                            width: geometry.size.width,
                            image: image,
                            takenPhoto: takenPhoto,
                            selectedPhoto: selectedPhoto,
                            edtiroState: $editorState,
                            editingSnapshot: $editingSnapshot
                        )
                        SpotPostTitle(title: $title)
                        if image != nil {
                            SpotPostGeoPoint(place: $placemark)
                        }
                        Spacer()

                        SpotPostSubmitButton(image: editingSnapshot ?? image, title: title, placemark: placemark, dismiss: dismiss)
                    }
                    .padding(.vertical, 24)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .background(Color.screenBackground.edgesIgnoringSafeArea(.all))
            .navigationBarItems(
                leading: Button(action: dismiss.callAsFunction, label: {
                    Image(systemName: "xmark")
                        .renderingMode(.template)
                        .foregroundColor(.appPrimary)
                })
            )
            .navigationBarTitle("", displayMode: .inline)
        }
    }

    private func takenPhoto(image: UIImage) {
        Task { @MainActor in
            if let userLocation = try? await locationManager.userLocation(),
               let placemark = try? await geocoder.reverseGeocode(location: userLocation).first {
                self.placemark = placemark
            }

            self.image = image
        }
    }

    private func selectedPhoto(photoLibraryResult: PhotoLibraryResult) {
        Task { @MainActor in
            if let location = photoLibraryResult.location,
               let placemark = try? await geocoder.reverseGeocode(location: location).first {
                self.placemark = placemark
            }

            let image = photoLibraryResult.image
            self.image = image
        }
    }
}

struct SpotListView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SpotPostView()
        }
    }
}
