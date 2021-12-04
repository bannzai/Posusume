import SwiftUI
import Combine
import MapKit
import Apollo

struct SpotMapView: View {
    @Environment(\.locationManager) var locationManager

    @StateObject var cache = Cache<SpotsQuery>()
    @StateObject var query = Query<SpotsQuery>()

    @State var spots: [SpotsQuery.Data.Spot] = []
    @State var error: Error?
    @State var region: MKCoordinateRegion?
    @State var isPresentingSpotPost = false;

    var body: some View {
        ZStack(alignment: .init(horizontal: .center, vertical: .bottom)) {
            Map(coordinateRegion: mapCoordinateRegion,
                showsUserLocation: true,
                annotationItems: spots,
                annotationContent: { spot in
                MapAnnotation(coordinate: spot.coordinate) {
                    SpotMapImage(fragment: spot.fragments.spotMapImageFragment)
                }
            }).onChange(of: mapCoordinateRegion.wrappedValue) { newRegion in
                fetchIfNeeded(region: newRegion)
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
                        self.spots += response.spots
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

                spots = await cache(for: .init(region: mapCoordinateRegion.wrappedValue))?.spots ?? []
                spots += try await query(for: .init(region: mapCoordinateRegion.wrappedValue)).spots
            } catch {
                self.error = error
            }
        }
    }

    // Workaround of SwiftUI.Map unavoidable warning
    // SwiftUI.Map(coordinateRegion: $region) is not working well
    // After update binding property of region on View#task(async) method,
    // SwiftUI send error about `Modifying state during view update, this will cause undefined behavior`
    // mapCoordinateRegion avoid this runtime warnings that wrapped and proxy for getting and setting region.
    // Reference: https://stackoverflow.com/questions/68271517/swiftui-onappear-modifying-state-during-view-update-this-will-cause-undefined-b
    private var mapCoordinateRegion: Binding<MKCoordinateRegion> {
        .init(get: { region ?? defaultRegion }, set: { newRegion in
            // Lazy set region after region set first time on View#task(async)
            if region != nil {
                region = newRegion
            }
        })
    }

    private func fetchIfNeeded(region: MKCoordinateRegion) {
        if query.isFetching {
            return
        }

        if spots.contains(where: { spot in
            region.minLatitude <= spot.geoPoint.latitude &&
            region.maxLatitude >= spot.geoPoint.latitude &&
            region.minLongitude <= spot.geoPoint.longitude &&
            region.maxLongitude >= spot.geoPoint.longitude
        }) {
            Task {
                if let response = try? await query(for: .init(region: region)) {
                    spots += response.spots
                }
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
