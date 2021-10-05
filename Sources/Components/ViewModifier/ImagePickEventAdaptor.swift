import Foundation
import SwiftUI

public struct ImagePickEventAdaptor: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    @State private var isPresentingCamera = false
    @State private var isPresentingPhotoLibrary = false
    @State private var presentingAlertType: AlertType?

    @Binding var showsActionSheet: Bool
    @Binding var error: Error?

    let takenPhoto: (UIImage) -> Void
    let selectedPhoto: (PhotoLibraryResult) -> Void

    enum AlertType: Int, Identifiable {
        case openSetting
        case choseNoPermission

        var id: Self { self }
    }

    public func body(content: Content) -> some View {
        content
            .actionSheet(
                isPresented: $showsActionSheet,
                content: {
                    ActionSheet(
                        title: Text("写真を1枚選んでください"),
                        buttons: [
                            .default(Text("撮影する"), action: {
                                isPresentingCamera = true
                            }),
                            .default(Text("写真から選択"), action: {
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
                            }),
                            .cancel(Text("キャンセル"))
                        ]
                    )
                }
            )
            .fullScreenCover(isPresented: $isPresentingCamera, content: {
                PhotoCameraView(taken: takenPhoto)
                    .ignoresSafeArea()
            })
            .sheet(
                isPresented: $isPresentingPhotoLibrary,
                content: {
                    PhotoLibraryView(
                        error: $error,
                        photoLibrary: photoLibrary,
                        selected: selectedPhoto
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
    }
}

extension View {
    func adaptImagePickEvent(
        showsActionSheet: Binding<Bool>,
        error: Binding<Error?>,
        takenPhoto: @escaping (UIImage) -> Void,
        selectedPhoto: @escaping (PhotoLibraryResult) -> Void
    ) -> some View {
        modifier(
            ImagePickEventAdaptor(
                showsActionSheet: showsActionSheet,
                error: error,
                takenPhoto: takenPhoto,
                selectedPhoto: selectedPhoto
            )
        )
    }
}

private func openSetting() {
    let settingURL = URL(string: UIApplication.openSettingsURLString)!
    if UIApplication.shared.canOpenURL(settingURL) {
        UIApplication.shared.open(settingURL)
    }
}
