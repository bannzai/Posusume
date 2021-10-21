import Foundation
import SwiftUI

public struct SpotPostEditorPage: View {
    let image: UIImage
    init(image: UIImage) {
        self.image = image
    }

    @State var textFieldValues: [TextFieldComponentValue] = []
    @State var selectedTextFieldValueID: TextFieldComponentValue.ID?
    @FocusState var elementTextFieldIsFocused: Bool

    public var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .clipped()

                    SpotPostEditorEffectCover(
                        textFieldValues: $textFieldValues,
                        selectedTextFieldValueID: $selectedTextFieldValueID,
                        elementTextFieldIsFocused: $elementTextFieldIsFocused
                    )
                }.spotImageFrame(width: geometry.size.width)
            }
            .onTapGesture {
                elementTextFieldIsFocused = false
                selectedTextFieldValueID = nil
            }

            ScrollView(.horizontal) {
                HStack {
                    if let selectedTextFieldIndex = selectedTextFieldIndex {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 32))
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                textFieldValues.remove(at: selectedTextFieldIndex)
                            }

                        ColorPicker("", selection: .init(get: { textFieldValues[selectedTextFieldIndex].textColor }, set: {
                            textFieldValues[selectedTextFieldIndex].textColor = $0
                        })).frame(width: 40, height: 40)

                        Image(systemName: "bold")
                            .font(.system(size: 32))
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                textFieldValues[selectedTextFieldIndex].isBold.toggle()
                            }

                        Image(systemName: "italic")
                            .font(.system(size: 32))
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                textFieldValues[selectedTextFieldIndex].isItalic.toggle()
                            }

                        Image(systemName: "underline")
                            .font(.system(size: 32))
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                textFieldValues[selectedTextFieldIndex].isUnderline.toggle()
                            }
                    } else {
                        Image(systemName: "textformat")
                            .font(.system(size: 32))
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                let element = TextFieldComponentValue(text: "Hello, world")
                                textFieldValues.append(element)
                                selectedTextFieldValueID = element.id
                            }
                    }
                }
            }
        }
        .padding()
    }

    private var selectedTextFieldIndex: Int? {
        textFieldValues.firstIndex(where: { $0.id == selectedTextFieldValueID })
    }
}


struct SpotPostEditorPage_Previews: PreviewProvider {
    static var previews: some View {
        SpotPostEditorPage(image: .init(named: "IMG_0005")!)
    }
}
