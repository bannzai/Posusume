import Foundation
import SwiftUI
import CoreLocation

public struct SpotPostSubmitButton: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject var upload = Upload()
    @StateObject var mutation = Mutation<SpotAddMutation>()

    @State var error: Error?

    @Binding var image: UIImage?
    @Binding var title: String
    @Binding var place: Place?

    var submitButtonIsDisabled: Bool {
        image == nil || title.isEmpty || place == nil
    }

    public var body: some View {
        Button(
            action: save,
            label: {
                Text("保存")
                    .foregroundColor(.white)
                    .font(.body)
                    .fontWeight(.medium)
            })
            .disabled(submitButtonIsDisabled)
            .buttonStyle(PrimaryButtonStyle(isLoading: mutation.isProcessing))
            .handle(error: $error)
    }

    private func save() {
        guard let image = image, let place = place else {
            return
        }
        Task {
            do {
            // TODO: fill values
                let uploaded = try await upload(path: .spot(userID: "", spotID: ""), image: image)
                try await mutation(
                    for: .init(
                        spotAddInput: .init(
                            title: title,
                            imageUrl: uploaded.url,
                            latitude: place.location.latitude,
                            longitude: place.location.longitude
                        )
                    )
                )
                dismiss()
            } catch {
                self.error = error
            }
        }
    }
}

