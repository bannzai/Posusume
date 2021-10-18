import Foundation
import SwiftUI

public struct SpotPostEditorPage: View {
    let image: UIImage

    public var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                Image(uiImage: image)
                    .resizable()
                    .spotImageFrame(width: geometry.size.width)
                    .clipped()
            }
            .padding()

            ScrollView(.horizontal) {
                HStack {
                    Image(systemName: "textbox")
                    Image(systemName: "face.smiling")
                }
                .padding()
            }
        }
    }

    enum ModifierType {
        case text
        case verticalText
        case emoji
        case asciiArt
    }
}


struct SpotPostEditorPage_Previews: PreviewProvider {
    static var previews: some View {
        SpotPostEditorPage(image: .init(named: "IMG_0005")!)
    }
}
