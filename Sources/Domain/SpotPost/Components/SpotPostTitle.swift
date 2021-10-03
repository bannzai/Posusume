import Foundation
import SwiftUI

public struct SpotPostTitle: View {
    @Binding var title: String

    public var body: some View {
        VStack(alignment: .leading) {
            Text("タイトル")
                .font(.subheadline)
            TextField("ポスターのタイトル", text: _title)
                .font(.caption)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(Color.white)
        }
    }
}

