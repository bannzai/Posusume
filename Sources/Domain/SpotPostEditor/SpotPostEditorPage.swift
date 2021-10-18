import Foundation
import SwiftUI

public struct SpotPostEditorPage: View {
    let image: UIImage

    public var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .spotImageFrame(width: UIScreen.main.bounds.width)

            ScrollView(.horizontal) {
                HStack {
                    Image(systemName: "textbox")
                    Image(systemName: "face.smiling")
                }
            }

            Spacer()
        }
    }
}
