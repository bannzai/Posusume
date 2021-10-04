import SwiftUI
import Combine
import MapKit
import CoreLocation

struct LocationSelectView: View {
    @Environment(\.locationManager) var locationManager
    @Environment(\.geocoder) var geocoder

    @State var error: Error?
    @State var searchText: String = ""
    @State var marks: [PlaceMark] = []
    @State var selectedMark: PlaceMark?
    @State var userLocation: CLLocation?

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
                        marks = try await geocoder.geocode(address: text)
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
                                openSetting()
                            case .requiredAutentification:
                                requestAuthentification()
                            }
                        }
                }
                ForEach(marks) { mark in
                    HStack {
                        Text(formatForLocation(mark: mark))
                            .font(.footnote)
                            .onTapGesture {
                                selectedMark = mark
                            }
                    }
                }
            }
        }
        .handle(error: $error)
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
                state.alert = .notPermission
            case .restricted:
                openSetting()
            @unknown default:
                assertionFailure("unexpected authorization status \(status):\(status.rawValue)")
            }
        }
    }
}

func formatForLocation(mark: PlaceMark) -> String {
    if !mark.name.isEmpty {
        return "\(mark.name): \(mark.address.address)"
    }
    return mark.address.address
}

struct LocationSelectView_Previews: PreviewProvider {
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
