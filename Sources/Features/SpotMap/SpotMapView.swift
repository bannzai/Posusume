import SwiftUI
import Combine
import MapKit
import Apollo

struct SpotMapView: View {
    @Environment(\.locationManager) var locationManager

    @StateObject var viewModel = SpotMapViewModel()

    @State var region: MKCoordinateRegion?
    @State var isPresentingSpotPost = false

    var body: some View {
        ZStack {
            Map(coordinateRegion: mapCoordinateRegion,
                showsUserLocation: true,
                annotationItems: viewModel.spots,
                annotationContent: { spot in
                MapAnnotation(coordinate: spot.coordinate) {
                    SpotMapImage(fragment: spot.fragments.spotMapImageFragment)
                }
            }).onChange(of: mapCoordinateRegion.wrappedValue) { newRegion in
                viewModel.fetch(region: newRegion)
            }
            .edgesIgnoringSafeArea(.all)

            VStack {
                SpotMapAccountIcon()
                    .frame(alignment: .top)

                Spacer()

                Button {
                    isPresentingSpotPost = true
                } label: {
                    Image("addSpot")
                        .frame(width: 64, height: 64, alignment: .center)
                        .background(GradientColor.barn)
                        .clipShape(Circle())
                }
                .frame(alignment: .bottom)
                .padding(.trailing, 20)
                .padding(.bottom, 60)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .sheet(
            isPresented: $isPresentingSpotPost,
            onDismiss: {
                viewModel.fetch(region: mapCoordinateRegion.wrappedValue)
            },
            content: {
                SpotPostView()
            }
        )
        .handle(error: $viewModel.error)
        .task {
            do {
                let userLocation = try await locationManager.userLocation()
                let region = MKCoordinateRegion(center: userLocation.coordinate, span: mapCoordinateRegion.wrappedValue.span)
                self.region = region

                viewModel.fetch(region: region)
            } catch {
                viewModel.error = error
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
