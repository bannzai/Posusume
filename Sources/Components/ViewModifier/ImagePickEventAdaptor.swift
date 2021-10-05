import Foundation
import SwiftUI

public struct ImagePickEventAdaptor: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    @State private var isCameraPresented = false
    @State private var isPhotoLibraryPresented = false
    @State private var presentingAlertType: AlertType?

    @Binding var showsActionSheet: Bool
    @Binding var photoLibraryResult: PhotoLibraryResult?
    @Binding var error: Error?

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
                                isCameraPresented = true
                            }),
                            .default(Text("写真から選択"), action: {
                                switch photoLibrary.prepareActionType() {
                                case nil:
                                    isPhotoLibraryPresented = true
                                case .openSettingApp:
                                    presentingAlertType = .openSetting
                                case .requestAuthorization:
                                    Task {
                                        let status = await photoLibrary.requestAuthorization()
                                        switch status {
                                        case .authorized, .limited:
                                            isPhotoLibraryPresented = true
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
            .fullScreenCover(isPresented: $isCameraPresented, content: {
                PhotoCameraView(captured: { image in

                }).ignoresSafeArea()
            })
            .sheet(
                isPresented: $isPhotoLibraryPresented,
                content: {
                    PhotoLibraryView(
                        photoLibrary: photoLibrary,
                        photoLibraryResult: $photoLibraryResult,
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
    }
}

extension View {
    func adaptImagePickEvent(showsActionSheet: Binding<Bool>, photoLibraryResult: Binding<PhotoLibraryResult?>, error: Binding<Error?>) -> some View {
        modifier(ImagePickEventAdaptor(showsActionSheet: showsActionSheet, photoLibraryResult: photoLibraryResult, error: error))
    }
}

private func openSetting() {
    let settingURL = URL(string: UIApplication.openSettingsURLString)!
    if UIApplication.shared.canOpenURL(settingURL) {
        UIApplication.shared.open(settingURL)
    }
}
