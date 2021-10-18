import Foundation
import SwiftUI

public struct SpotPostEditorPage: View {
    let image: UIImage
    init(image: UIImage) {
        self.image = image
    }

    public var body: some View {
        VStack {
            GeometryReader { geometry in
                Image(uiImage: image)
                    .resizable()
                    .spotImageFrame(width: geometry.size.width)
                    .clipped()
            }

            ScrollView(.horizontal) {
                HStack {
                    Image(systemName: "textbox")
                    Image(systemName: "textbox")
                    Image(systemName: "face.smiling")
                }
            }
        }
        .padding()
    }
}


struct SpotPostEditorPage_Previews: PreviewProvider {
    static var previews: some View {
        SpotPostEditorPage(image: .init(named: "IMG_0005")!)
    }
}
