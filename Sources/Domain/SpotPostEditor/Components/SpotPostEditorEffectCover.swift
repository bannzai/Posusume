import Foundation
import SwiftUI

struct SpotPostEditorEffectCover: View {
    @Binding var elements: [SpotPostEditorEffectCoverElementValue]
    @Binding var selectedElementID: SpotPostEditorEffectCoverElementValue.ID?
    @FocusState.Binding var elementTextFieldIsFocused: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach($elements) { $element in
                    SpotPostEditorEffectCoverElement(
                        element: $element,
                        isSelected: .init(get: { element.id == selectedElementID }, set: { value in
                            if value {
                                selectedElementID = element.id
                            } else {
                                selectedElementID = nil
                            }
                        }),
                        location: .init(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY),
                        isFocused: _elementTextFieldIsFocused
                    )
                }
            }
        }
    }
}

struct SpotPostEditorEffectCoverElement: View {
    @Binding var element: SpotPostEditorEffectCoverElementValue
    @Binding var isSelected: Bool
    @State var location: CGPoint
    @FocusState.Binding var isFocused: Bool

    @State private var currentRotation: Angle = .zero
    @State private var currentMagnification: CGFloat = 1
    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var twistAngle: Angle = .zero
    @GestureState private var pinchMagnification: CGFloat = 1

    var body: some View {
        TextField("", text: $element.text)
            .focused(_isFocused)
            .foregroundColor(element.textColor)
            .font(.title.weight(element.isBold ? .bold : .medium))
            .fixedSize()
            .padding(4)
            .border(isSelected ? Color.blue : Color.clear, width: 2)
            .rotationEffect(currentRotation + twistAngle)
            .scaleEffect(currentMagnification * pinchMagnification)
            .position(location)
            .clipped()
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

struct SpotPostEditorEffectCoverElementValue: Identifiable, Equatable {
    let id: UUID = .init()
    var text: String
    var textColor: Color = .black
    var isBold: Bool = false
}


struct SpotPostEditorEffectCover_Previews: PreviewProvider {
    @State static var elements: [SpotPostEditorEffectCoverElementValue] = [.init(text: "Hello, world", textColor: .black)]
    @FocusState static var elementIsFocused: Bool
    static var previews: some View {
        SpotPostEditorEffectCover(elements: $elements,
                                  selectedElementID: .constant(nil),
                                  elementTextFieldIsFocused: $elementIsFocused)
    }
}
