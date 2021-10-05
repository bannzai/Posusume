import Foundation
import SwiftUI

struct SpotPostImage: View {
    @Environment(\.geocoder) var geocoder

    @State var isPresentingPhotoLibrary: Bool = false
    @State var presentingAlertType: AlertType?
    @State var error: Error?

    @Binding var photoLibraryResult: PhotoLibraryResult?
    @Binding var photoLibraryPlacemark: Placemark?

    enum AlertType: Int, Identifiable {
        case openSetting
        case choseNoPermission

        var id: Self { self }
    }

    var body: some View {
        Button (
            action: {
                switch photoLibrary.prepareActionType() {
                case nil:
                    isPresentingPhotoLibrary = true
                case .openSettingApp:
                    presentingAlertType = .openSetting
                case .requestAuthorization:
                    Task {
                        let status = await photoLibrary.requestAuthorization()
                        switch status {
                        case .authorized, .limited:
                            isPresentingPhotoLibrary = true
                        case .denied, .restricted, .notDetermined:
                            presentingAlertType = .choseNoPermission
                        @unknown default:
                            assertionFailure("New case \(status)")
                        }
                    }
                }
            },
            label: {
                if let image = photoLibraryResult?.image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: .infinity)
                        .aspectRatio(.init(width: 4, height: 3), contentMode: .fit)
                        .clipped()
                } else {
                    VStack {
                        Spacer()
                        Image("anyPicture")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        Text("画像を選択")
                            .font(.footnote)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(.init(width: 4, height: 3), contentMode: .fit)
                    .foregroundColor(.placeholder)
                    .background(Color.white)
                }
            })
            .buttonStyle(PlainButtonStyle())
            .sheet(
                isPresented: $isPresentingPhotoLibrary,
                content: {
                    PhotoLibraryView(
                        photoLibrary: photoLibrary,
                        photoLibraryResult: Binding(get: {
                            photoLibraryResult
                        }, set: { photoLibraryResult in
                            Task {
                                if let photoLibraryResultLocation = photoLibraryResult?.location {
                                    photoLibraryPlacemark = try? await geocoder.reverseGeocode(location: photoLibraryResultLocation).first
                                }
                                self.photoLibraryResult = photoLibraryResult
                            }
                        }),
                        error: $error
                    )
                }
            )
            .alert(item: $presentingAlertType, content: { alertType in
                switch alertType {
                case .openSetting:
                    return Alert(
                        title: Text("画像を選択できません"),
                        message: Text("フォトライブラリのアクセスが許可されていません。設定アプリから許可をしてください"),
                        primaryButton: .default(Text("設定を開く"), action: openSetting),
                        secondaryButton: .cancel()
                    )
                case .choseNoPermission:
                    return Alert(
                        title: Text("アクセスを拒否しました"),
                        message: Text("フォトライブラリのアクセスが拒否されました。操作を続ける場合は設定アプリから許可をしてください"),
                        primaryButton: .default(Text("設定を開く"), action: openSetting),
                        secondaryButton: .cancel()
                    )
                }
            })
            .handle(error: $error)
    }


    private func openSetting() {
        let settingURL = URL(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }
}


private struct Preview: PreviewProvider {
    @State static var photoLibraryResult: PhotoLibraryResult?
    @State static var photoLibraryResultPlacemark: Placemark?
    static var previews: some View {
        SpotPostImage(photoLibraryResult: $photoLibraryResult, photoLibraryPlacemark: $photoLibraryResultPlacemark)
    }
}
