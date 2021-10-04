import SwiftUI
 
struct LocationSelectSearchBar: View {
    @State var isEditing = false

    @Binding var text: String
    let onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("検索", text: $text)
                .disableAutocorrection(true)
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    isEditing = true
                }

            if isEditing {
                Button(action: {
                    isEditing = false
                    onSearch()
                }) {
                    Text("検索")
                }
                .padding(.trailing, 16)
            }
        }
        .padding(.vertical, 4)
        .frame(maxHeight: 50)
    }
}

private struct Previews: PreviewProvider {
    static var text = ""
    static var previews: some View {
        LocationSelectSearchBar(text: Binding(get: { text }, set: { text = $0 }), onSearch: {})
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 44))
    }
}
