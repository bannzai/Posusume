import Foundation
import SwiftUI

struct TextFieldComponent: View {
    @Binding var value: TextFieldComponentValue
    @Binding var isSelected: Bool
    @State var location: CGPoint
    @FocusState.Binding var isFocused: Bool

    @State private var currentRotation: Angle = .zero
    @State private var currentMagnification: CGFloat = 1
    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var twistAngle: Angle = .zero
    @GestureState private var pinchMagnification: CGFloat = 1

    var body: some View {
        Group {
            if value.isVertical {
                Tansaku(value.text)
            } else {
                if value.isUnderline {
                    VStack(spacing: -2) {
                        TextField("", text: $value.text)

                        Divider()
                            .frame(height: 1)
                            .background(value.textColor)
                    }
                } else {
                    TextField("", text: $value.text)
                }
            }
        }
        .focused(_isFocused)
        .foregroundColor(value.textColor)
        .font(font)
        .fixedSize()
        .padding(4)
        .border(isSelected ? Color.blue : Color.clear, width: 2)
        .rotationEffect(currentRotation + twistAngle)
        .scaleEffect(currentMagnification * pinchMagnification)
        .position(location)
        .clipped()
        .gesture(drag.simultaneously(with: rotation).simultaneously(with: magnification))
    }

    private var font: SwiftUI.Font {
        var font = Font.title
        if value.isBold {
            font = font.weight(.bold)
        }
        if value.isItalic {
            font = font.italic()
        }
        return font
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

struct TextFieldComponentValue: Identifiable, Equatable {
    let id: UUID = .init()
    var text: String
    var textColor: Color = .black
    var isBold = false
    var isItalic = false
    var isUnderline = false
    var isVertical = false {
        didSet {
            if isVertical {
                isUnderline = false
            }
        }
    }
}

