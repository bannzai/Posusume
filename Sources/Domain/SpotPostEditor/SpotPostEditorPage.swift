import Foundation
import SwiftUI

public struct SpotPostEditorPage: View {
    let image: UIImage
    init(image: UIImage) {
        self.image = image
    }

    @State var elements: [SpotPostEditorEffectCoverElementValue] = []
    @State var selectedElementID: SpotPostEditorEffectCoverElementValue.ID?
    @FocusState var elementTextFieldIsFocused: Bool

    public var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .spotImageFrame(width: geometry.size.width)
                        .clipped()
                }
                SpotPostEditorEffectCover(
                    elements: $elements,
                    selectedElementID: $selectedElementID,
                    elementTextFieldIsFocused: $elementTextFieldIsFocused
                )
            }
            .onTapGesture {
                elementTextFieldIsFocused = false
                selectedElementID = nil
            }

            ScrollView(.horizontal) {
                HStack {
                    Image(systemName: "textformat")
                        .font(.system(size: 32))
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            let element = SpotPostEditorEffectCoverElementValue(text: "Hello, world", textColor: .red)
                            elements.append(element)
                            selectedElementID = element.id
                        }

                    if let selectedElement = selectedElement {
                        ColorPicker(selectedElement.text, selection: .init(get: { selectedElement.textColor }, set: {
                            if let index = elements.firstIndex(where: { $0.id == selectedElementID }) {
                                elements[index].textColor = $0
                            }
                        })).frame(width: 40, height: 40)
                    }
                }
            }
        }
        .padding()
    }

    private var selectedElement: SpotPostEditorEffectCoverElementValue? {
        elements.first(where: { $0.id == selectedElementID })
    }
}


struct SpotPostEditorPage_Previews: PreviewProvider {
    static var previews: some View {
        SpotPostEditorPage(image: .init(named: "IMG_0005")!)
    }
}
