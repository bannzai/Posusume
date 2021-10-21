import Foundation
import SwiftUI

struct SpotPostEditorEffectCover: View {
    @Binding var elements: [SpotPostEditorEffectCoverElementValue]
    @Binding var selected: SpotPostEditorEffectCoverElementValue?
    @FocusState.Binding var elementTextFieldIsFocused: Bool

    var body: some View {
        ZStack {
            ForEach($elements) { $element in
                SpotPostEditorEffectCoverElement(
                    element: $element,
                    isSelected: .init(get: { element.id == selected?.id }, set: { value in
                        if value {
                            selected = element
                        } else {
                            selected = nil
                        }
                    }),
                    isFocused: _elementTextFieldIsFocused
                )
            }
        }
    }
}

struct SpotPostEditorEffectCoverElement: View {
    @Binding var element: SpotPostEditorEffectCoverElementValue
    @Binding var isSelected: Bool

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
            .border(isSelected ? Color.blue : Color.clear, width: 2)
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

                isSelected = true
            }
            .updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location
            }
    }

    private var rotation: some Gesture {
        RotationGesture()
            .onChanged { _ in
                isSelected = true
            }
            .onEnded { value in
                currentRotation += value
            }
            .updating($twistAngle) { (currentState, twistAngle, transaction) in
                twistAngle = currentState
            }
    }

    private var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { _ in
                isSelected = true
            }
            .onEnded { value in
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
        SpotPostEditorEffectCover(elements: $elements,
                                  selected: .constant(nil),
                                  elementTextFieldIsFocused: $elementIsFocused)
    }
}
