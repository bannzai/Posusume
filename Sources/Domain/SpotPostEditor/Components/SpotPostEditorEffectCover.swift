import Foundation
import SwiftUI

struct SpotPostEditorEffectCover: View {
    @Binding var elements: [TextFieldComponentValue]
    @Binding var selectedElementID: TextFieldComponentValue.ID?
    @FocusState.Binding var elementTextFieldIsFocused: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach($elements) { $element in
                    TextFieldComponent(
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


struct SpotPostEditorEffectCover_Previews: PreviewProvider {
    @State static var elements: [TextFieldComponentValue] = [.init(text: "Hello, world", textColor: .black)]
    @FocusState static var elementIsFocused: Bool
    static var previews: some View {
        SpotPostEditorEffectCover(elements: $elements,
                                  selectedElementID: .constant(nil),
                                  elementTextFieldIsFocused: $elementIsFocused)
    }
}
