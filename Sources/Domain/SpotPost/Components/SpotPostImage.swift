import Foundation
import SwiftUI

struct SpotPostImage: View {
    @Binding var image: UIImage?
    @State var showsActionSheet: Bool = false

    var body: some View {
        Button (
            action: {
                showsActionSheet = true
            },
            label: {
                if let image = image {
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
            .adaptImagePickEvent(showsActionSheet: $showsActionSheet)
    }
}


struct Preview: PreviewProvider {
    static var previews: some View {
        SpotPostImage(image: .init(get: { nil }, set: { _ in }))
    }
}
