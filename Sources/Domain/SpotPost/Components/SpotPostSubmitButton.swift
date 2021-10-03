import Foundation
import SwiftUI
import CoreLocation

public struct SpotPostSubmitButton: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject var upload = Upload()
    @StateObject var mutation = Mutation<SpotAddMutation>()

    @State var error: IdentifiableError?

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
            .alert(item: $error) { error in
                Alert(title: Text("エラーが発生しました"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
            }
    }

    private func save() {
        guard let image = image, let geoPoint = geoPoint else {
            return
        }
        Task {
            // TODO:
            do {
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
                self.error = .init(error)
            }
        }
    }
}

