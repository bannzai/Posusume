import Foundation
import SwiftUI

struct SpotPostImage: View {
    @Environment(\.geocoder) var geocoder

    @State var showsActionSheet: Bool = false
    @State var error: Error?

    let width: CGFloat
    let image: UIImage?
    let takenPhoto: ((UIImage) -> Void)
    let selectedPhoto: (PhotoLibraryResult) -> Void

    var body: some View {
        Button (
            action: {
                showsActionSheet = true
            },
            label: {
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
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
                        .foregroundColor(.placeholder)
                    }
                }
                .spotImageFrame(width: width)
                .background(Color.white)
            })
            .buttonStyle(PlainButtonStyle())
            .clipped()
            .adaptImagePickEvent(
                showsActionSheet: $showsActionSheet,
                error: $error,
                takenPhoto: takenPhoto,
                selectedPhoto: selectedPhoto
            )
            .handle(error: $error)
    }
}


private struct Preview: PreviewProvider {
    static var previews: some View {
        SpotPostImage(width: UIScreen.main.bounds.width - 40, image: nil, takenPhoto: { _ in }, selectedPhoto: { _ in })
    }
}
