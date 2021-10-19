import Foundation
import SwiftUI

struct SpotPostEditorEffectCover: View {
    @Binding var elements: [SpotPostEditorEffectCoverElement]

    var body: some View {
        ZStack {
            ForEach(elements) { element in
                Text(element.text)
                    .font(.title)
                    .position(element.location)
                    .gesture(
                        DragGesture()
                            .onChanged { gestureValue in
                                guard let elementIndex = elements.firstIndex(where: { $0.id == element.id }) else {
                                    fatalError()
                                }
                                elements[elementIndex].location = gestureValue.location
                            }
                    )
            }
        }
    }
}

struct SpotPostEditorEffectCoverElement: Identifiable {
    let id: UUID = .init()
    let text: String
    var location: CGPoint = .init(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    let defaultLocation: CGPoint

    init(text: String, location: CGPoint) {
        self.text = text
        self.location = location
        self.defaultLocation = location
    }
}



struct SpotPostEditorEffectCover_Previews: PreviewProvider {
    @State static var elements: [SpotPostEditorEffectCoverElement] = [.init(text: "Hello, world", location: .zero)]
    static var previews: some View {
        V()
    }
}
