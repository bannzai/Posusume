import Foundation
import SwiftUI
import MapKit

public struct MapKitMapView: UIViewRepresentable {
    public typealias UIViewType = MKMapView

    public func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.isZoomEnabled = true
        view.isScrollEnabled = true
        view.isPitchEnabled = true
        view.isRotateEnabled = true
        view.delegate = context.coordinator
        view.mapType = .standard
        view.userTrackingMode = .follow
        view.showsUserLocation = true
        view.showsCompass = false
        return view
    }

    public func updateUIView(_ uiView: MKMapView, context: Context) {

    }

    public class Coordinator: NSObject {
        let view: MapKitMapView

        init(view: MapKitMapView) {
            self.view = view
        }
    }

    public func makeCoordinator() -> Coordinator {
        .init(view: self)
    }
}


extension MapKitMapView.Coordinator: MKMapViewDelegate {

}

