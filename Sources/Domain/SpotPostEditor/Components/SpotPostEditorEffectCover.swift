import Foundation
import SwiftUI

struct SpotPostEditorEffectCover: View {
    @Binding var elements: [SpotPostEditorEffectCoverElementValue]

    var body: some View {
        ZStack {
            ForEach(elements) { element in
                SpotPostEditorEffectCoverElement(element: element)
            }
        }
    }
}

struct SpotPostEditorEffectCoverElement: View {
    let element: SpotPostEditorEffectCoverElementValue

    @State private var location: CGPoint = CGPoint(x: 40, y: 40)
    @State private var angle: Angle = .init(degrees: 0)
    @State private var isGesturing: Bool = false
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
            .when(isGesturing) {
                $0.border(Color.blue, width: 2)
            }
    }

    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                location = newLocation

                isGesturing = true
            }
            .onEnded { _ in
                isGesturing = false
            }
            .updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location
            }
    }

    private var rotate: some Gesture {
        RotationGesture()
            .onChanged { angle in
                self.angle = angle

                isGesturing = true
            }
            .onEnded { _ in
                isGesturing = false
            }
    }
}

extension SpotPostEditorEffectCoverElement: Equatable {
    static func ==(lhs: SpotPostEditorEffectCoverElement, rhs: SpotPostEditorEffectCoverElement) -> Bool {
        lhs.element == rhs.element
    }
}

struct SpotPostEditorEffectCoverElementValue: Identifiable, Equatable {
    let id: UUID = .init()
    let text: String
}


struct SpotPostEditorEffectCover_Previews: PreviewProvider {
    @State static var elements: [SpotPostEditorEffectCoverElementValue] = [.init(text: "Hello, world")]
    static var previews: some View {
        SpotPostEditorEffectCover(elements: $elements)
    }
}
