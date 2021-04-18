import Foundation
import UIKit
import SwiftUI
import PhotosUI
import Photos
import ComposableArchitecture

struct PhotoSelectState: Equatable {
    var selectedImage: UIImage?
    var isPresentOpenSettingAppAlert: Bool
    var isPresentNotPermissionAlert: Bool
    var error: EquatableError?
}

enum PhotoSelectAction: Equatable {
    case prepare
    case authorized(Result<PHAuthorizationStatus, Never>)
    case selected([PHPickerResult])
    case converted(Result<PhotoLibraryConvertResult, EquatableError>)
    case end(PhotoLibraryConvertResult)
    case presentOpenSettingAlert
    case openSetting
    case presentedOpenSetting
    case presentNotPermissionAlert
    case confirmedNotPermission
    case cancelAlertAction
}

struct PhotoSelectEnvironment {
    let me: Me
    let photoLibrary: PhotoLibrary
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

let reducer: Reducer<PhotoSelectState, PhotoSelectAction, PhotoSelectEnvironment> = .init { state, action, environment in
    switch action {
    case .prepare:
        switch environment.photoLibrary.prepareActionType() {
        case nil:
            return .none
        case .openSettingApp:
            return Effect(value: .presentOpenSettingAlert)
        case .requestAuthorization:
            return environment
                .photoLibrary
                .requestAuthorization()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(PhotoSelectAction.authorized)
        }
    case let .authorized(.success(status)):
        switch status {
        case .authorized:
            return .none
        case .limited:
            return .none
        case .notDetermined:
            return Effect(value: .presentNotPermissionAlert)
        case .denied:
            return Effect(value: .presentNotPermissionAlert)
        case .restricted:
            return Effect(value: .presentNotPermissionAlert)
        @unknown default:
            assertionFailure("unexpected authorization status \(status):\(status.rawValue)")
            return .none
        }
    case let .selected(selectedResults):
        guard let selected = selectedResults.first else {
            fatalError("unexpected selectedResult is empty")
        }
        return environment
            .photoLibrary
            .convert(pickerResult: selected)
            .mapError(EquatableError.init(error:))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(PhotoSelectAction.converted)
    case let .converted(.success(result)):
        return Effect(value: .end(result))
    case let .converted(.failure(error)):
        state.error = error
        return .none
    case .end:
        return .none
    case .presentOpenSettingAlert:
        state.isPresentOpenSettingAppAlert = true
        return .none
    case .openSetting:
        guard UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) else {
            assertionFailure("unexpected cannot open setting apps")
            return .none
        }
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        return Effect(value: .presentedOpenSetting)
    case .presentedOpenSetting:
        state.isPresentOpenSettingAppAlert = false
        return .none
    case .presentNotPermissionAlert:
        state.isPresentNotPermissionAlert = true
        return .none
    case .confirmedNotPermission:
        state.isPresentNotPermissionAlert = false
        return .none
    case .cancelAlertAction:
        state.isPresentOpenSettingAppAlert = false
        state.isPresentNotPermissionAlert = false
        return .none
    }
}

struct PhotoSelectView: View {
    var body: some View {
        EmptyView()
    }
}

struct PhotoSelectView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelectView()
    }
}
