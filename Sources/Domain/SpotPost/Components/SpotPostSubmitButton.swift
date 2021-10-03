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
    @Binding var geoPoint: CLLocationCoordinate2D?

    var submitButtonIsDisabled: Bool {
        image == nil || title.isEmpty || geoPoint == nil
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
        guard let image = image, let geoPoint = geoPoint else {
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
                            latitude: geoPoint.latitude,
                            longitude: geoPoint.longitude
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

