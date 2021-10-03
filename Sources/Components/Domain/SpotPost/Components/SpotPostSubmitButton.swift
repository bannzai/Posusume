import Foundation
import SwiftUI

public struct SpotPostSubmitButton: View {
    let isDisabled: Bool

    public var body: some View {
        Button(
            action: {
                // TODO:
            },
            label: {
                Text("保存")
                    .foregroundColor(.white)
                    .font(.body)
                    .fontWeight(.medium)
            })
            .disabled(isDisabled)
            .frame(width: 200, height: 44, alignment: .center)
            .background(isDisabled ? Color.disabled.gradient : GradientColor.barn
            )
    }
}

