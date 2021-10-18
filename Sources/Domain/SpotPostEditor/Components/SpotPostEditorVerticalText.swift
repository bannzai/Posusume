import Foundation
import SwiftUI

struct SpotPostEditorVerticalText: View {
    let sources: [String]
    let onTap: (String) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(0..<sources.count) { offset in
                    Tansaku(sources[offset])
                        .onTapGesture {
                            onTap(sources[offset])
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

struct SpotPostEditorVerticalText_Previews: PreviewProvider {
    static var previews: some View {
        SpotPostEditorVerticalText(sources: ["翼", "陽炎", "麻婆豆腐", "茶封筒", "カブトムシ", "らせん階段", "カブト虫", "廃墟の街", "イチジクのタルト", "カブト虫", "ドロローサへの道", "カブト虫", "特異点", "ジョット", "エンジェル", "紫陽花", "カブト虫", "特異点", "秘密の皇帝"], onTap: { _ in })
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 100))
    }
}
