import Foundation
import SwiftUI

public struct Tansaku: View {
    let string: String

    public var body: some View {
        VStack {
            ForEach(0..<string.count) { offset in
                Text(String(string[string.index(string.startIndex, offsetBy: offset)]))
            }
        }
    }
}

struct Tansaku_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Tansaku(string: "こんにちは")
            Tansaku(string: "abcdefg")
        }
    }
}
