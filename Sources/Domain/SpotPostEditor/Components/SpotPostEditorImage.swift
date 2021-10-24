import Foundation
import SwiftUI

public struct SpotPostEditorImage: View {
    let width: CGFloat
    let image: UIImage

    @Binding var textFieldStatuses: [TextFieldComponentState]
    @Binding var selectedTextFieldStateID: TextFieldComponentState.ID?
    @FocusState.Binding var textFieldIsFocused: Bool

    public var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .spotImageFrame(width: width)
                .clipped()

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
        .spotImageFrame(width: width)
    }
}
