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
    @State private var isGesturing = false
    @State private var scale: CGFloat = 1.0
    @GestureState private var startLocation: CGPoint? = nil

    var body: some View {
        Text(element.text)
            .font(.title)
            .padding(4)
            .border(isGesturing ? Color.blue : Color.clear, width: 2)
            .rotationEffect(.degrees(angle.degrees))
            .scaleEffect(scale)
            .position(location)
            .gesture(drag.simultaneously(with: rotate).simultaneously(with: magnification))

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

    private var magnification: some Gesture {
        MagnificationGesture().onChanged { value in
            scale = value.magnitude
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
