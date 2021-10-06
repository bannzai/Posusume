import Foundation
import SwiftUI
import CoreLocation

public struct SpotPostSubmitButton: View {
    @Environment(\.me) var me
    @Environment(\.dismiss) var dismiss

    @StateObject var upload = Upload()
    @StateObject var mutation = Mutation<SpotAddMutation>()

    @State var error: Error?

    let image: UIImage?
    let title: String
    let placemark: Placemark?

    var submitButtonIsDisabled: Bool {
        image == nil || title.isEmpty || placemark == nil
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
        if submitButtonIsDisabled {
            return
        }
        guard let image = image, let placemark = placemark else {
            return
        }
        Task {
            do {
                let spotID = generateDatabaseID()
                let uploaded = try await upload(path: .spot(userID: me.id, spotID: spotID), image: image)
                try await mutation(
                    for: .init(
                        spotAddInput: .init(
                            id: spotID,
                            title: title,
                            imageUrl: uploaded.url,
                            latitude: placemark.location.latitude,
                            longitude: placemark.location.longitude
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

