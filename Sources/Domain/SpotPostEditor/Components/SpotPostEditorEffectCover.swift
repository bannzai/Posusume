import Foundation
import SwiftUI

struct SpotPostEditorEffectCover: View {
    @Binding var elements: [SpotPostEditorEffectCoverElementValue]
    @FocusState.Binding var elementTextFieldIsFocused: Bool

    var body: some View {
        ZStack {
            ForEach($elements) { $element in
                SpotPostEditorEffectCoverElement(element: $element, isFocused: _elementTextFieldIsFocused)
            }
        }
    }
}

struct SpotPostEditorEffectCoverElement: View {
    @Binding var element: SpotPostEditorEffectCoverElementValue

    @State private var isGesturing = false
    @State private var location: CGPoint = CGPoint(x: 40, y: 40)
    @State private var currentRotation: Angle = .zero
    @State private var currentMagnification: CGFloat = 1
    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var twistAngle: Angle = .zero
    @GestureState private var pinchMagnification: CGFloat = 1
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        TextField("", text: $element.text)
            .focused(_isFocused)
            .font(.title)
            .fixedSize()
            .padding(4)
            .border(isGesturing ? Color.blue : Color.clear, width: 2)
            .rotationEffect(currentRotation + twistAngle)
            .scaleEffect(currentMagnification * pinchMagnification)
            .position(location)
            .gesture(drag.simultaneously(with: rotation).simultaneously(with: magnification))

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

    private var rotation: some Gesture {
        RotationGesture()
            .onChanged { _ in
                isGesturing = true
            }
            .onEnded { value in
                isGesturing = false
                currentRotation += value
            }
            .updating($twistAngle) { (currentState, twistAngle, transaction) in
                twistAngle = currentState
            }
    }

    private var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { _ in
                isGesturing = true
            }
            .onEnded { value in
                isGesturing = false
                currentMagnification *= value
            }
            .updating($pinchMagnification) { (currentState, pinchMagnification, transaction) in
                pinchMagnification = currentState
            }
    }
}

struct SpotPostEditorEffectCoverElementValue: Identifiable {
    let id: UUID = .init()
    var text: String
}


struct SpotPostEditorEffectCover_Previews: PreviewProvider {
    @State static var elements: [SpotPostEditorEffectCoverElementValue] = [.init(text: "Hello, world")]
    @FocusState static var elementIsFocused: Bool
    static var previews: some View {
        SpotPostEditorEffectCover(elements: $elements, elementTextFieldIsFocused: $elementIsFocused)
    }
}
