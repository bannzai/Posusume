import Foundation
import SwiftUI

struct SpotPostImage: View {
    @Environment(\.geocoder) var geocoder

    @State var showsActionSheet: Bool = false
    @State var error: Error?

    @Binding var photoLibraryResult: PhotoLibraryResult?
    @Binding var photoLibraryPlacemark: Placemark?

    var body: some View {
        Button (
            action: {
                showsActionSheet = true
            },
            label: {
                if let image = photoLibraryResult?.image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: .infinity)
                        .aspectRatio(.init(width: 4, height: 3), contentMode: .fit)
                        .clipped()
                } else {
                    VStack {
                        Spacer()
                        Image("anyPicture")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        Text("画像を選択")
                            .font(.footnote)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(.init(width: 4, height: 3), contentMode: .fit)
                    .foregroundColor(.placeholder)
                    .background(Color.white)
                }
            })
            .buttonStyle(PlainButtonStyle())
            .adaptImagePickEvent(
                showsActionSheet: $showsActionSheet,
                photoLibraryResult: Binding(get: {
                    photoLibraryResult
                }, set: { photoLibraryResult in
                    Task {
                        if let photoLibraryResultLocation = photoLibraryResult?.location {
                            photoLibraryPlacemark = try? await geocoder.reverseGeocode(location: photoLibraryResultLocation).first
                        }
                        self.photoLibraryResult = photoLibraryResult
                    }
                }),
                error: $error
            )
            .handle(error: $error)
    }
}


private struct Preview: PreviewProvider {
    @State static var photoLibraryResult: PhotoLibraryResult?
    @State static var photoLibraryResultPlacemark: Placemark?
    static var previews: some View {
        SpotPostImage(photoLibraryResult: $photoLibraryResult, photoLibraryPlacemark: $photoLibraryResultPlacemark)
    }
}
