import SwiftUI
import Combine
import MapKit

struct SpotMapView: View {
    var body: some View {
        Text("Hello, world")
//        WithViewStore(store) { viewStore in
//            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
//                Map(
//                    coordinateRegion: viewStore.binding(
//                        get: \.region,
//                        send: { .regionChange(center: $0.center, span: .init(span: $0.span)) }
//                    ),
//                    showsUserLocation: true,
//                    annotationItems: viewStore.state.spots,
//                    annotationContent: { spot in
//                        MapAnnotation(coordinate: spot.coordinate) {
//                            Text(spot.title)
//                        }
//                    }
//                )
//
//                VStack(spacing: -32) {
//                    HStack {
//                        Spacer()
//                        Button {
//                            viewStore.send(.presentSpotPost(nil))
//                        } label: {
//                            Image("addSpot")
//                                .frame(width: 64, height: 64, alignment: .center)
//                                .background(GradientColor.lower)
//                                .clipShape(Circle())
//                        }
//                    }
//                    .padding(.trailing, 20)
//
//                    ZStack {
//                        BarnBottomSheet()
//                        SpotList(
//                            state: viewStore.state.spotListState
//                        )
//                        .frame(alignment: .bottom)
//                        .padding()
//                    }
//                    .frame(width: UIScreen.main.bounds.width, height: BarnBottomSheet.height, alignment: .bottom)
//                }
//            }
//            .onAppear { viewStore.send(.fetch) }
//            .sheet(
//                isPresented: viewStore.binding(
//                    get: \.isPresentedSpotPostPage,
//                    send: { .spotPostPresentationDidChanged($0) }
//                ),
//                content: {
//                    IfLetStore(
//                        store.scope(
//                            state: \.spotPost,
//                            action: {
//                                .spotPostAction($0)
//                            }
//                        ),
//                        then: SpotPostView.init(store:))
//                }
//            )
//        }
    }
}


struct SpotMapView_Previews: PreviewProvider {
    static var previews: some View {
        SpotMapView()
    }
}
