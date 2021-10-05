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
    @State var image: UIImage?
    @State var title: String = ""
    @State var place: Placemark?

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        SpotPostImage(image: $image)
                        SpotPostTitle(title: $title)
                        SpotPostGeoPoint(place: $place)
                        Spacer()
                        SpotPostSubmitButton(
                            image: $image,
                            title: $title,
                            place: $place
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
                if place == nil, let userLocation = try? await locationManager.userLocation() {
                    place = try? await geocoder.reverseGeocode(location: userLocation).first
                }
            }
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
