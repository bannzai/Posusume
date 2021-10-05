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
    @State var photoLibraryResult: PhotoLibraryResult?
    @State var photoLibraryPlacemark: Placemark?
    @State var title: String = ""
    @State var userInputPlacemark: Placemark?

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        SpotPostImage(photoLibraryResult: $photoLibraryResult, photoLibraryPlacemark: $photoLibraryPlacemark)
                        SpotPostTitle(title: $title)
                        if isUnknownPhotoLibraryResultLocation {
                            SpotPostGeoPoint(place: $userInputPlacemark)
                        }
                        Spacer()
                        SpotPostSubmitButton(
                            photoLibraryResult: photoLibraryResult,
                            title: title,
                            placemark: photoLibraryPlacemark ?? userInputPlacemark
                        )
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
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
            .task {
                if userInputPlacemark == nil, let userLocation = try? await locationManager.userLocation() {
                    userInputPlacemark = try? await geocoder.reverseGeocode(location: userLocation).first
                }
            }
        }
    }

    private var isUnknownPhotoLibraryResultLocation: Bool {
        photoLibraryResult != nil && photoLibraryPlacemark == nil
    }
}

struct SpotListView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SpotPostView()
        }
    }
}
