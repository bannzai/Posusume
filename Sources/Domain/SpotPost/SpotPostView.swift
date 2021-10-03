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

    @State var error: Error?
    @State var image: UIImage?
    @State var title: String = ""
    @State var geoPoint: CLLocationCoordinate2D?

    var submitButtonIsDisabled: Bool {
        image == nil || title.isEmpty || geoPoint == nil
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
                        PrimaryButton(
                            isLoading: mutation.isProcessing,
                            action: {
                                guard let image = image, let geoPoint = geoPoint else {
                                    return
                                }
                                Task {
                                    // TODO:
                                    do {
                                        let uploaded = try await upload(path: .spot(userID: "", spotID: ""), image: image)
                                        try await mutation(
                                            for: .init(
                                                spotAddInput: .init(
                                                    title: title,
                                                    imageUrl: uploaded.url,
                                                    latitude: geoPoint.latitude,
                                                    longitude: geoPoint.longitude
                                                )
                                            )
                                        )
                                        presentationMode.wrappedValue.dismiss()
                                    } catch {
                                        self.error = error
                                    }
                                }
                            }, label: {
                                Text("保存")
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .fontWeight(.medium)
                            })
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
