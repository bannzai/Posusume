import SwiftUI
import Combine
import MapKit
import CoreLocation
import Location
import AppError

public struct LocationSelectView: View {
    @Environment(\.locationManager) var locationManager
    @Environment(\.geocoder) var geocoder
    @Environment(\.dismiss) var dismiss

    @State var error: Error?
    @State var searchText: String = ""
    @State var searchedPlacemarks: [Placemark] = []
    @State var userPlacemarks: [Placemark] = []

    @Binding var selectedPlacemark: Placemark?
    public init(selectedPlacemark: Binding<Placemark?>) {
        self._selectedPlacemark = selectedPlacemark
    }

    public var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(userPlacemarks) { mark in
                    HStack {
                        Image(systemName: "location.circle")
                        Text("現在地: \(mark.formattedLocationAddress())")
                            .font(.footnote)
                            .onTapGesture {
                                selectedPlacemark = mark
                                dismiss()
                            }
                    }
                }
                ForEach(searchedPlacemarks) { mark in
                    HStack {
                        Text(mark.formattedLocationAddress())
                            .font(.footnote)
                            .onTapGesture {
                                selectedPlacemark = mark
                                dismiss()
                            }
                    }
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("住所を入力"))
        .onSubmit(of: .search) {
            Task {
                do {
                    searchedPlacemarks = try await geocoder.geocode(address: searchText)
                } catch {
                    self.error = error
                }
            }
        }
        .navigationTitle(Text("撮影場所を選択"))
        .handle(error: $error)
        .task {
            do {
                let userLocation = try await locationManager.userLocation()
                userPlacemarks = try await geocoder.reverseGeocode(location: userLocation)
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
