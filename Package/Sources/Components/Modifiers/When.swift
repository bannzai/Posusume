import Foundation
import SwiftUI

extension View {
    /// Applies the given transform when the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` when the condition is `true`.
    @ViewBuilder func when<Content: View>(_ condition: Bool, to transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
