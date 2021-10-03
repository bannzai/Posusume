import Foundation
import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    let isLoading: Bool

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                !isEnabled ? Color.disabled.gradient : GradientColor.barn
            )
            .overlay(content: {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            })
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .disabled(!isEnabled || isLoading)
    }
}
