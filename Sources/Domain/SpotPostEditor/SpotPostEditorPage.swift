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
        VStack {
            GeometryReader { geometry in
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .clipped()

                    SpotPostEditorEffectCover(
                        textFieldValues: $textFieldValues,
                        selectedTextFieldValueID: $selectedTextFieldValueID,
                        textFieldIsFocused: $textFieldIsFocused
                    )
                }.spotImageFrame(width: geometry.size.width)
            }
            .onTapGesture {
                textFieldIsFocused = false
                selectedTextFieldValueID = nil
            }

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
