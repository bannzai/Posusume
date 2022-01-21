import Foundation
import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    let isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }

    public func makeBody(configuration: Configuration) -> some View {
        if isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color.disabled.gradient)
                .opacity(0.7)
                .disabled(true)
        } else {
            configuration.label
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    !isEnabled ? Color.disabled.gradient : GradientColor.barn
                )
                .opacity(configuration.isPressed ? 0.7 : 1.0)
                .disabled(!isEnabled || isLoading)
        }
    }
}
