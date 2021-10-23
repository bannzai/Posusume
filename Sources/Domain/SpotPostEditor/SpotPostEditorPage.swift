import Foundation
import SwiftUI

public struct SpotPostEditorPage: View {
    let image: UIImage
    init(image: UIImage) {
        self.image = image
    }

    @State var textFieldValues: [TextFieldComponentValue] = []
    @State var selectedTextFieldValueID: TextFieldComponentValue.ID?
    @FocusState var textFieldIsFocused: Bool

    public var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                SpotPostEditorImage(image: image)

                SpotPostEditorEffectCover(
                    textFieldValues: $textFieldValues,
                    selectedTextFieldValueID: $selectedTextFieldValueID,
                    textFieldIsFocused: $textFieldIsFocused
                )
            }
            .onTapGesture {
                textFieldIsFocused = false
                selectedTextFieldValueID = nil
            }
            .edgesIgnoringSafeArea(.all)

            ScrollView(.horizontal) {
                HStack {
                    if let selectedTextFieldIndex = selectedTextFieldIndex {
                        TextFieldComponentModifiers(textFieldValue: .init(get: {
                            textFieldValues[selectedTextFieldIndex]
                        }, set: {
                            textFieldValues[selectedTextFieldIndex] = $0
                        }), onDelete: {
                            textFieldValues.remove(at: selectedTextFieldIndex)
                        })
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
            .frame(width: UIScreen.main.bounds.width)
            .padding()
        }
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
