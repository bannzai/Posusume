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

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        SpotPostImage(
                            width: geometry.size.width,
                            image: image,
                            takenPhoto: takenPhoto,
                            selectedPhoto: selectedPhoto
                        )
                        SpotPostTitle(title: $title)
                        if image != nil {
                            SpotPostGeoPoint(place: $placemark)
                        }
                        Spacer()

                        SpotPostSubmitButton(image: image, title: title, placemark: placemark)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets.init(top: 16, leading: 20, bottom: 32, trailing: 20))
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
        Task {
            if let userLocation = try? await locationManager.userLocation(),
               let placemark = try? await geocoder.reverseGeocode(location: userLocation).first {
                self.placemark = placemark
            }
            self.image = image
        }
    }

    private func selectedPhoto(photoLibraryResult: PhotoLibraryResult) {
        Task {
            if let location = photoLibraryResult.location,
               let placemark = try? await geocoder.reverseGeocode(location: location).first {
                self.placemark = placemark
            }
            image = photoLibraryResult.image
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
