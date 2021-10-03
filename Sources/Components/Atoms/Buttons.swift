import Foundation
import SwiftUI

public struct PrimaryButton<Label: View>: View {
    let isLoading: Bool
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    public init(
        isLoading: Bool,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.isLoading = isLoading
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button( action: action, label: label)
            .overlay(content: {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            })
            .frame(maxWidth: .infinity)
            .buttonStyle(PrimaryButtonStyle())
            .disabled(isLoading)
    }
}

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                !isEnabled ? Color.disabled.gradient : GradientColor.barn
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}
