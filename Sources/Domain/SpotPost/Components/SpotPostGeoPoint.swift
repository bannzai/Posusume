import Foundation
import SwiftUI
import CoreLocation

public struct SpotPostGeoPoint: View {
    @Binding var place: Placemark?

    public var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: LocationSelectView(selectedPlacemark: _place)) {
                if let place = place {
                    Text(place.formattedLocationAddress())
                } else {
                    Text("撮影場所を選択してください")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .font(.subheadline)
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
    }
}

