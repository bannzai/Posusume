import Foundation
import SwiftUI

struct TextFieldComponent: View {
    @Binding var state: TextFieldComponentState
    @Binding var isSelected: Bool
    @FocusState.Binding var isFocused: Bool

    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var twistAngle: Angle = .zero
    @GestureState private var pinchMagnification: CGFloat = 1

    var body: some View {
        Group {
            if state.isVertical {
                Tansaku(state.text)
            } else {
                VStack(spacing: -2) {
                    TextField("", text: $state.text)

                    if state.isUnderline {
                        Divider()
                            .frame(height: 1)
                            .background(state.textColor)
                    }
                }
            }
        }
        .focused(_isFocused)
        .foregroundColor(state.textColor)
        .font(font)
        .fixedSize()
        .padding(4)
        .border(isSelected ? Color.blue : Color.clear, width: 2)
        .rotationEffect(state.rotation + twistAngle)
        .position(state.location)
        .clipped()
        .gesture(drag.simultaneously(with: rotation).simultaneously(with: magnification))
    }

    private var font: SwiftUI.Font {
        var font = Font.system(size: 24 * state.maginification * pinchMagnification)
        if state.isBold {
            font = font.weight(.bold)
        }
        if state.isItalic {
            font = font.italic()
        }
        return font
    }

    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? state.location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                state.location = newLocation

                isSelected = true
            }
            .updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? state.location
            }
    }

    private var rotation: some Gesture {
        RotationGesture()
            .onChanged { _ in
                isSelected = true
            }
            .onEnded { value in
                state.rotation += value
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
                state.maginification *= value
            }
            .updating($pinchMagnification) { (currentState, pinchMagnification, transaction) in
                pinchMagnification = currentState
            }
    }
}

public struct TextFieldComponentState: Identifiable, Equatable {
    public let id: UUID = .init()
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

    // Keep gesture state
    var location: CGPoint = .init(x: UIScreen.main.bounds.width, y: 200)
    var rotation: Angle = .zero
    var maginification: CGFloat = 1

    public init(text: String) {
        self.text = text
    }
}

