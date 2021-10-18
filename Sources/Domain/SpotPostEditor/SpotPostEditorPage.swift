import Foundation
import SwiftUI

public struct SpotPostEditorPage: View {
    let image: UIImage
    init(image: UIImage) {
        self.image = image
    }

    @State var modifierType: ModifierType = .text

    public var body: some View {
        VStack {
            GeometryReader { geometry in
                Image(uiImage: image)
                    .resizable()
                    .spotImageFrame(width: geometry.size.width)
                    .clipped()
            }

            switch modifierType {
            case .text:
                SpotPostEditorText(sources: ["翼", "陽炎", "スターください", "麻婆豆腐"], onTap: { _ in

                })
            case .verticalText:
                SpotPostEditorVerticalText(sources: ["翼", "陽炎", "スターください", "麻婆豆腐"], onTap: { _ in

                })
            case .emoji:
                SpotPostEditorEmoji(onTap: { _ in

                })
            }

            ScrollView(.horizontal) {
                HStack {
                    Image(systemName: "textbox")
                        .onTapGesture { modifierType = .text }
                    Image(systemName: "textbox")
                        .onTapGesture { modifierType = .verticalText }
                    Image(systemName: "face.smiling")
                        .onTapGesture { modifierType = .emoji }
                }
            }
        }
        .padding()
    }

    enum ModifierType {
        case text
        case verticalText
        case emoji
    }
}


struct SpotPostEditorPage_Previews: PreviewProvider {
    static var previews: some View {
        SpotPostEditorPage(image: .init(named: "IMG_0005")!)
    }
}
