import SwiftUI
import Combine
import MapKit

struct SpotMapView: View {
    @Environment(\.locationManager) var locationManager

    @StateObject var cache = Cache<SpotsQuery>()
    @StateObject var query = Query<SpotsQuery>()

    @State var response: SpotsQuery.Data?
    @State var error: Error?
    @State var region: MKCoordinateRegion?
    @State var isPresentingSpotPost = false;

    var spots: [SpotsQuery.Data.Spot] {
        response?.spots ?? []
    }

    private var mapCoordinateRegion: Binding<MKCoordinateRegion> {
        .init(get: { region ?? defaultRegion }, set: { newRegion in
            if region != nil {
                region = newRegion
            }
        })
    }

    var body: some View {
        ZStack(alignment: .init(horizontal: .center, vertical: .bottom)) {
            Map(coordinateRegion: mapCoordinateRegion,
                showsUserLocation: true,
                annotationItems: spots,
                annotationContent: { spot in
                MapAnnotation(coordinate: spot.coordinate) {
                    SpotMapImage(fragment: spot.fragments.spotMapImageFragment)
                }
            }).onChange(of: region) { newRegion in
                print("newRegion: ", newRegion)
            }

            HStack(alignment: .bottom) {
                Spacer()
                Button {
                    isPresentingSpotPost = true
                } label: {
                    Image("addSpot")
                        .frame(width: 64, height: 64, alignment: .center)
                        .background(GradientColor.barn)
                        .clipShape(Circle())
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 60)
        }
        .sheet(
            isPresented: $isPresentingSpotPost,
            onDismiss: {
                Task {
                    if let response = try? await query(for: .init(region: mapCoordinateRegion.wrappedValue)) {
                        self.response = response
                    }
                }
            },
            content: {
                SpotPostView()
            }
        )
        .handle(error: $error)
        .edgesIgnoringSafeArea(.all)
        .task {
            do {
                let userLocation = try await locationManager.userLocation()
                region = .init(center: userLocation.coordinate, span: mapCoordinateRegion.wrappedValue.span)

                response = await cache(for: .init(region: mapCoordinateRegion.wrappedValue))
                response = try await query(for: .init(region: mapCoordinateRegion.wrappedValue))
            } catch {
                self.error = error
            }
        }
    }
}


struct SpotMapView_Previews: PreviewProvider {
    static var previews: some View {
        SpotMapView()
    }
}

extension SpotsQuery.Data.Spot: Identifiable {
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
}

extension SpotsQuery {
    convenience init(region: MKCoordinateRegion) {
        self.init(
            spotsMinLatitude: region.minLatitude,
            spotsMinLongitude: region.minLongitude,
            spotsMaxLatitude: region.maxLatitude,
            spotsMaxLongitude: region.maxLongitude
        )
    }
}
