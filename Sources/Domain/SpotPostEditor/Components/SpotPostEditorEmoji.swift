import Foundation
import SwiftUI

struct SpotPostEditorEmoji: View {
    let emojies = (0x1F601...0x1F64F).compactMap(UnicodeScalar.init).map(String.init)
    let onTap: (String) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(0..<emojies.count) { offset in
                    Text(emojies[offset])
                        .onTapGesture {
                            onTap(emojies[offset])
                        }
                }
            }
        }
    }

    private var rows: [GridItem] {
        .init(
            repeating: .init(.flexible(minimum: 20, maximum: .infinity), spacing: 10, alignment: .center),
            count: 3
        )
    }
}

struct SpotPostEditorEmoji_Previews: PreviewProvider {
    static var previews: some View {
        SpotPostEditorEmoji(onTap: { _ in })
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 100))
    }
}
