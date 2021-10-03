import Foundation
import SwiftUI
import CoreLocation

public struct SpotPostGeoPoint: View {
    @Binding var geoPoint: CLLocationCoordinate2D?

    public var body: some View {
        VStack(alignment: .leading) {
            Button(
                action: {
                    // TODO:
                },
                label: {
                    if let geoPoint = geoPoint {
                        Text("画像を撮った場所を選んでください")
                            .font(.subheadline)
                    } else {
                        Text("画像を撮った場所を選んでください")
                            .font(.subheadline)
                    }
                }
            )
        }
        .frame(maxWidth: .infinity)
    }
}

