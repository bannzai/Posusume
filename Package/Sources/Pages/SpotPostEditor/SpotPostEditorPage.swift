import Foundation
import SwiftUI

public struct SpotPostEditorPageState {
    public internal(set) var textFieldValues: [TextFieldComponentState] = []

    public init() { }
}

public struct SpotPostEditorPage: View {
    @Binding var state: SpotPostEditorPageState
    let image: UIImage
    let snapshotOnDisappear: (SpotPostEditorImage) -> Void
    public init(state: Binding<SpotPostEditorPageState>, image: UIImage, snapshotOnDisappear: @escaping (SpotPostEditorImage) -> Void) {
        self._state = state
        self.image = image
        self.snapshotOnDisappear = snapshotOnDisappear
    }

    @State var selectedTextFieldStateID: TextFieldComponentState.ID?
    @FocusState var textFieldIsFocused: Bool

    public var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    // Keep view geometry width for snapshot. If get geometry.size.width directoly when snapshot, return difference width
                    let width = geometry.size.width
                    SpotPostEditorImage(
                        width: width,
                        image: image,
                        textFieldStatuses: $state.textFieldValues,
                        selectedTextFieldStateID: $selectedTextFieldStateID,
                        textFieldIsFocused: $textFieldIsFocused
                    ).onDisappear(perform: {
                        snapshotOnDisappear(
                            .init(width: width,
                                  image: image,
                                  textFieldStatuses: $state.textFieldValues,
                                  selectedTextFieldStateID: .constant(nil),
                                  textFieldIsFocused: $textFieldIsFocused)
                        )
                    })
                }
                .onTapGesture {
                    textFieldIsFocused = false
                    selectedTextFieldStateID = nil
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
                                    selectedTextFieldStateID = element.id
                                }
                        }
                    }
                }
                .padding(.bottom)
            }
            .padding(.horizontal, 20)
        }
    }

    private var selectedTextFieldIndex: Int? {
        state.textFieldValues.firstIndex(where: { $0.id == selectedTextFieldStateID })
    }
}


struct SpotPostEditorPage_Previews: PreviewProvider {
    static var previews: some View {
        SpotPostEditorPage(state: .constant(.init()), image: .init(named: "IMG_0005")!, snapshotOnDisappear: { _ in })
    }
}
