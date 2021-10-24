import Foundation
import SwiftUI

public struct SpotPostEditorPageState {
    public internal(set) var textFieldValues: [TextFieldComponentState] = []

    public init() {

    }
}

public struct SpotPostEditorPage: View {
    let image: UIImage
    @Binding var state: SpotPostEditorPageState
    public init(image: UIImage, state: Binding<SpotPostEditorPageState>) {
        self.image = image
        self._state = state
    }

    @State var selectedTextFieldValueID: TextFieldComponentState.ID?
    @FocusState var textFieldIsFocused: Bool

    public var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .clipped()

                        SpotPostEditorEffectCover(
                            textFieldStatuses: $state.textFieldValues,
                            selectedTextFieldStateID: $selectedTextFieldValueID,
                            textFieldIsFocused: $textFieldIsFocused
                        )
                    }
                    .spotImageFrame(width: geometry.size.width)
                }
                .onTapGesture {
                    textFieldIsFocused = false
                    selectedTextFieldValueID = nil
                }

                ScrollView(.horizontal) {
                    HStack {
                        if let selectedTextFieldIndex = selectedTextFieldIndex {
                            TextFieldComponentModifiers(textFieldValue: .init(get: {
                                state.textFieldValues[selectedTextFieldIndex]
                            }, set: {
                                state.textFieldValues[selectedTextFieldIndex] = $0
                            }), onDelete: {
                                state.textFieldValues.remove(at: selectedTextFieldIndex)
                            })
                        } else {
                            Image(systemName: "textformat")
                                .font(.system(size: 32))
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    let element = TextFieldComponentState(text: "Hello, world")
                                    state.textFieldValues.append(element)
                                    selectedTextFieldValueID = element.id
                                }
                        }
                    }
                }
            }
            .padding()
        }
    }

    private var selectedTextFieldIndex: Int? {
        state.textFieldValues.firstIndex(where: { $0.id == selectedTextFieldValueID })
    }
}


struct SpotPostEditorPage_Previews: PreviewProvider {
    @State static var state: SpotPostEditorPageState = .init()
    static var previews: some View {
        SpotPostEditorPage(image:.init(named: "IMG_0005")!, state: $state)
    }
}
