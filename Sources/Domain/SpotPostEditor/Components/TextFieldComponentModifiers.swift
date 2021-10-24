import Foundation
import SwiftUI

struct TextFieldComponentModifiers: View {
    @Binding var textFieldValue: TextFieldComponentState
    let onDelete: () -> Void

    var body: some View {
        Image(systemName: "trash.fill")
            .font(.system(size: 32))
            .frame(width: 40, height: 40)
            .onTapGesture(perform: onDelete)

        ColorPicker("", selection: .init(get: { textFieldValue.textColor }, set: {
            textFieldValue.textColor = $0
        })).frame(width: 40, height: 40)

        Image(systemName: "bold")
            .font(.system(size: 32))
            .frame(width: 40, height: 40)
            .onTapGesture {
                textFieldValue.isBold.toggle()
            }

        Image(systemName: "italic")
            .font(.system(size: 32))
            .frame(width: 40, height: 40)
            .onTapGesture {
                textFieldValue.isItalic.toggle()
            }

        Image(systemName: "underline")
            .font(.system(size: 32))
            .frame(width: 40, height: 40)
            .onTapGesture {
                textFieldValue.isUnderline.toggle()
            }

        Image(systemName: "v.square")
            .font(.system(size: 32))
            .frame(width: 40, height: 40)
            .onTapGesture {
                textFieldValue.isVertical.toggle()
            }
    }
}
