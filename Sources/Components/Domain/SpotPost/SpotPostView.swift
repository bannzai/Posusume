import SwiftUI
import Combine
import CoreLocation
import PhotosUI
import Photos
import MapKit
import FirebaseStorageSwift

struct SpotPostView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var upload = Upload()
    @StateObject var mutation = Mutation<SpotAddMutation>()

    @State var image: UIImage?
    @State var title: String = ""
    @State var geoPoint: CLLocationCoordinate2D?

    var submitButtonIsDisabled: Bool {
        image == nil || title.isEmpty
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color.screenBackground.edgesIgnoringSafeArea(.all)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        SpotPostImage(image: $image)
                        SpotPostTitle(title: $title)
                        SpotPostGeoPoint(geoPoint: $geoPoint)
                        Spacer()
                        SpotPostSubmitButton(isDisabled: submitButtonIsDisabled)
                        Spacer().frame(height: 32)
                    }
                }
            }
            .padding(.vertical, 16)
            .navigationBarItems(
                leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .foregroundColor(.appPrimary)
                    }
            )
            .navigationBarTitle("", displayMode: .inline)
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
