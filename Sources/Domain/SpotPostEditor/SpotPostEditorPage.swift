import Foundation
import SwiftUI

public struct SpotPostEditorPage: View {
    let image: UIImage
    init(image: UIImage) {
        self.image = image
    }

    public var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .spotImageFrame(width: geometry.size.width)
                        .clipped()
                }
                SpotPostEditorEffectCover()
            }

            ScrollView(.horizontal) {
                HStack {
                    Image(systemName: "textformat")
                        .font(.system(size: 32))
                        .onTapGesture {

                        }
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
