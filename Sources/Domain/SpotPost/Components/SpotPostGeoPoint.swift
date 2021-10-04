import Foundation
import SwiftUI
import CoreLocation

public struct SpotPostGeoPoint: View {
    @Binding var place: Place?

    public var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: LocationSelectView(selectedPlace: _place)) {
                if let place = place {
                    Text(place.formattedLocationAddress())
                        .font(.subheadline)
                } else {
                    Text("画像を撮った場所を選んでください")
                        .font(.subheadline)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

