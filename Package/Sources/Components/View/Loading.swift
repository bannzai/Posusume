import Foundation
import SwiftUI

public struct Loading<Content: View, Value>: View {
    let value: Value?
    @ViewBuilder let content: (Value) -> Content

    public init(value: Value?, @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.content = content
    }

    public var body: some View {
        if let value = value {
            content(value)
        } else {
            ProgressView("Now Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
