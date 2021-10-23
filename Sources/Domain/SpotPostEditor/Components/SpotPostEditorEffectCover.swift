import Foundation
import SwiftUI

struct SpotPostEditorEffectCover: View {
    @Binding var textFieldStatuses: [TextFieldComponentState]
    @Binding var selectedTextFieldStateID: TextFieldComponentState.ID?
    @FocusState.Binding var textFieldIsFocused: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach($textFieldStatuses) { $state in
                    TextFieldComponent(
                        state: $state,
                        isSelected: .init(get: { state.id == selectedTextFieldStateID }, set: { value in
                            if value {
                                selectedTextFieldStateID = state.id
                            } else {
                                selectedTextFieldStateID = nil
                            }
                        }),
                        isFocused: _textFieldIsFocused
                    )
                }
            }
        }
    }
}


struct SpotPostEditorEffectCover_Previews: PreviewProvider {
    @State static var textFieldStatuses: [TextFieldComponentState] = [.init(text: "Hello, world")]
    @FocusState static var elementIsFocused: Bool
    static var previews: some View {
        SpotPostEditorEffectCover(textFieldStatuses: $textFieldStatuses,
                                  selectedTextFieldStateID: .constant(nil),
                                  textFieldIsFocused: $elementIsFocused)
    }
}
