import Foundation
import SwiftUI
import Apollo
import MapKit

public struct SpotDetailPage: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var cache = Cache<SpotQuery>()
    @StateObject var query = Query<SpotQuery>()

    @State var response: SpotQuery.Data?
    @State var error: Error?

    let spotID: String

    public var body: some View {
        NavigationView {
            Loading(value: response) { response in
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            SpotDetailImage(
                                width: geometry.size.width,
                                fragment: response.spot.fragments.spotDetailImageFragment
                            )

                            Map(mapRect: .constant(mapRect(response: response, geometryWidth: geometry.size.width)),
                                annotationItems: [response.spot],
                                annotationContent: { spot in
                                MapPin(coordinate: .init(latitude: spot.geoPoint.latitude, longitude: spot.geoPoint.longitude))
                            }).frame(maxWidth: .infinity, idealHeight: 200)
                        }
                        .padding(.vertical, 24)
                    }
                }
                .navigationBarItems(
                    leading: Button(action: dismiss.callAsFunction, label: {
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .foregroundColor(.appPrimary)
                    })
                )
                .navigationBarTitle(response.spot.title, displayMode: .inline)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .background(Color.screenBackground.edgesIgnoringSafeArea(.all))
            .task {
                if let response = await cache(for: .init(spotId: spotID)) {
                    self.response = response
                }

                do {
                    response = try await query(for: .init(spotId: spotID))
                } catch {
                    self.error = error
                }
            }
            .handle(error: $error)
        }
    }

    private func mapRect(response: SpotQuery.Data, geometryWidth: CGFloat) -> MKMapRect {
        // NOTE: size: .init() means fitting to SwiftUI frame
        .init(origin: .init(.init(latitude: response.spot.geoPoint.latitude, longitude: response.spot.geoPoint.longitude)), size: .init())
    }
}

extension SpotQuery.Data.Spot: Identifiable {

}
