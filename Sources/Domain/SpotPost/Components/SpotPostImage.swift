import Foundation
import SwiftUI

public struct SpotPostImage: View {
    @Binding var image: UIImage?
    @State var showsActionSheet: Bool = false

    public var body: some View {
        Button (
            action: {
                showsActionSheet = true
            },
            label: {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .aspectRatio(3 / 4, contentMode: .fit)
                        .clipped()
                } else {
                    VStack {
                        Image("anyPicture")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        Text("画像を選択")
                            .font(.footnote)
                    }
                    .foregroundColor(.placeholder)
                    .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 160)
                    .background(Color.white)
                }
            })
            .buttonStyle(PlainButtonStyle())
            .adaptImagePickEvent(showsActionSheet: $showsActionSheet)
    }
}

