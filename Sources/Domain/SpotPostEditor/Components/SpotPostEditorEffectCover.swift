import Foundation
import SwiftUI

struct SpotPostEditorEffectCover: View {
    @Binding var textFieldValues: [TextFieldComponentValue]
    @Binding var selectedTextFieldValueID: TextFieldComponentValue.ID?
    @FocusState.Binding var textFieldIsFocused: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach($textFieldValues) { $textFieldValue in
                    TextFieldComponent(
                        value: $textFieldValue,
                        isSelected: .init(get: { textFieldValue.id == selectedTextFieldValueID }, set: { value in
                            if value {
                                selectedTextFieldValueID = textFieldValue.id
                            } else {
                                selectedTextFieldValueID = nil
                            }
                        }),
                        location: .init(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY),
                        isFocused: _textFieldIsFocused
                    )
                }
            }
        }
    }
}


struct SpotPostEditorEffectCover_Previews: PreviewProvider {
    @State static var textFieldValues: [TextFieldComponentValue] = [.init(text: "Hello, world", textColor: .black)]
    @FocusState static var elementIsFocused: Bool
    static var previews: some View {
        SpotPostEditorEffectCover(textFieldValues: $textFieldValues,
                                  selectedTextFieldValueID: .constant(nil),
                                  textFieldIsFocused: $elementIsFocused)
    }
}
