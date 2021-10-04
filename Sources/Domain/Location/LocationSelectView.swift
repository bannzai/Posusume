import SwiftUI
import Combine
import MapKit
import CoreLocation

struct LocationSelectView: View {
    @Environment(\.locationManager) var locationManager
    @Environment(\.geocoder) var geocoder

    @State var error: Error?
    @State var searchText: String = ""
    @State var places: [Place] = []
    @State var userLocation: CLLocation?
    @State var presentingAlertType: AlertType?

    @Binding var selectedPlace: Place?

    enum AlertType: Int, Identifiable {
        case openSetting
        case choseNoPermission

        var id: Self { self }
    }

    var body: some View {
        VStack(alignment: .leading) {
            LocationSelectSearchBar(
                isEditing: true,
                text: .init(get: { searchText }, set: { text in
                    searchText = text
                    Task {
                        do {
                        places = try await geocoder.geocode(address: text)
                        } catch {
                            self.error = error
                        }
                    }
                })
            )
            List {
                HStack {
                    Image(systemName: "location.circle")
                    Text("現在地を選択")
                        .font(.headline)
                        .onTapGesture {
                            switch locationManager.prepareActionType() {
                            case nil:
                                updateUserLocation()
                            case .openSettingApp:
                                presentingAlertType = .openSetting
                            case .requiredAutentification:
                                requestAuthentification()
                            }
                        }
                }
                ForEach(places) { mark in
                    HStack {
                        Text(mark.formattedLocationAddress())
                            .font(.footnote)
                            .onTapGesture {
                                selectedPlace = mark
                            }
                    }
                }
            }
        }
        .handle(error: $error)
        .alert(item: $presentingAlertType, content: { alertType in
            switch alertType {
            case .openSetting:
                return Alert(
                    title: Text("位置情報を取得できません"),
                    message: Text("位置情報の取得が許可されていません。設定アプリから許可をしてください"),
                    primaryButton: .default(Text("設定を開く"), action: openSetting),
                    secondaryButton: .cancel()
                )
            case .choseNoPermission:
                return Alert(
                    title: Text("位置情報の取得を拒否しました"),
                    message: Text("位置情報の取得が拒否されました。操作を続ける場合は設定アプリから許可をしてください"),
                    primaryButton: .default(Text("設定を開く"), action: openSetting),
                    secondaryButton: .cancel()
                )
            }
        })
    }

    private func updateUserLocation() {
        Task {
            do {
                userLocation = try await locationManager.userLocation()
            } catch {
                self.error = error
            }
        }
    }

    private func requestAuthentification() {
        Task {
            let status = await locationManager.requestAuthorization()
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                return
            case .notDetermined:
                return
            case .denied:
                presentingAlertType = .choseNoPermission
            case .restricted:
                presentingAlertType = .openSetting
            @unknown default:
                assertionFailure("unexpected authorization status \(status):\(status.rawValue)")
            }
        }
    }
}

private struct Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LocationSelectView()
                .previewDisplayName("empty search text")
        }
    }
}

private func openSetting() {
    let settingURL = URL(string: UIApplication.openSettingsURLString)!
    if UIApplication.shared.canOpenURL(settingURL) {
        UIApplication.shared.open(settingURL)
    }
}
