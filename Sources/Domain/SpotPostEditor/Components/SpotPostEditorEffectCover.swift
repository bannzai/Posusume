import Foundation
import SwiftUI

struct SpotPostEditorEffectCover: View {
    @State var selected: SpotPostEditorEffectCoverElementValue?
    @Binding var elements: [SpotPostEditorEffectCoverElementValue]

    var body: some View {
        ZStack {
            ForEach(elements) { element in
                SpotPostEditorEffectCoverElement(element: element)
                    .when(element.id == selected?.id) {
                        $0
                            .border(Color.blue, width: 2)
                            .cornerRadius(4)
                    }
            }
        }
    }
}

struct SpotPostEditorEffectCoverElement: View {
    let element: SpotPostEditorEffectCoverElementValue

    @State private var location: CGPoint = CGPoint(x: UIScreen.main.bounds.midX, y: 200)
    @State private var angle: Angle = .init(degrees: 0)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil

    var body: some View {
        Text(element.text)
            .font(.title)
            .position(location)
            .rotationEffect(angle)
            .gesture(
                drag.simultaneously(with: rotate)
            )
    }

    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location
            }
    }

    private var rotate: some Gesture {
        RotationGesture()
            .onChanged { angle in
                self.angle = angle
            }
    }
}

struct SpotPostEditorEffectCoverElementValue: Identifiable {
    let id: UUID = .init()
    let text: String
}


struct SpotPostEditorEffectCover_Previews: PreviewProvider {
    @State static var elements: [SpotPostEditorEffectCoverElementValue] = [.init(text: "Hello, world")]
    static var previews: some View {
        SpotPostEditorEffectCover(elements: $elements)
    }
}
