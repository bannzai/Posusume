import SwiftUI
 
struct SearchBar: View {
    @State var isEditing = false
    @Binding var text: String
    var isDisableAutocorrection: Bool = false

    var body: some View {
        HStack {
            TextField("検索", text: $text)
                .disableAutocorrection(isDisableAutocorrection)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    if self.isDisableAutocorrection {
                        return
                    }
                    self.isEditing = true
                }

            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                }) {
                    Text("キャンセル")
                }
                .padding(.trailing, 10)
            }
        }
        .padding(.vertical, 4)
        .frame(maxHeight: 50)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var text = ""
    static var previews: some View {
        SearchBar(text: Binding(get: { text }, set: { text = $0 }))
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 44))
    }
}
