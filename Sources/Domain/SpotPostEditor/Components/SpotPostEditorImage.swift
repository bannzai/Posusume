import Foundation
import SwiftUI

struct SpotPostEditorImage: View {
    let width: CGFloat
    let image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .spotImageFrame(width: width)
            .clipped()
    }
}
