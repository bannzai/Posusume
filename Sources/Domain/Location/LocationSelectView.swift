import SwiftUI
import Combine
import MapKit
import CoreLocation

struct LocationSelectView: View {
    @Environment(\.locationManager) var locationManager
    @Environment(\.geocoder) var geocoder

    @State var error: Error?
    @State var searchText: String = ""
    @State var places: [Placemark] = []
    @State var userLocation: CLLocation?

    @Binding var selectedPlacemark: Placemark?

    var body: some View {
        VStack(alignment: .leading) {
            List {
                HStack {
                    Image(systemName: "location.circle")
                    Text("現在地を選択")
                        .font(.headline)
                        .onTapGesture {
                            updateUserLocation()
                        }
                }
                ForEach(places) { mark in
                    HStack {
                        Text(mark.formattedLocationAddress())
                            .font(.footnote)
                            .onTapGesture {
                                selectedPlacemark = mark
                            }
                    }
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("住所を入力"))
        .onSubmit(of: .search) {
            Task {
                do {
                    places = try await geocoder.geocode(address: searchText)
                } catch {
                    self.error = error
                }
            }
        }
        .navigationTitle(Text("撮影場所を選択"))
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
}

private struct LocationSelectView_Previews: PreviewProvider {
    @State static var place: Placemark?
    static var previews: some View {
        Group {
            LocationSelectView(selectedPlacemark: $place)
        }
    }
}
