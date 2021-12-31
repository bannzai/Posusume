import Foundation
import SwiftUI
import MapKit

public struct MapKitMapView: UIViewRepresentable {
    public typealias UIViewType = MKMapView

    let annotationContent: (SpotMapImageFragment) -> SpotMapImage

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


        view.register(SpotMapImageAnnotationView.self, forAnnotationViewWithReuseIdentifier: SpotMapImageAnnotationView.reuseIdentifier)
        view.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        return view
    }

    public func updateUIView(_ uiView: MKMapView, context: Context) {

    }

    public class Coordinator: NSObject {
        let mapView: MapKitMapView

        init(mapView: MapKitMapView) {
            self.mapView = mapView
        }
    }

    public func makeCoordinator() -> Coordinator {
        .init(mapView: self)
    }
}


extension MapKitMapView.Coordinator: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            // NOTE: Current user/device location
            return nil;
        }

        guard let annotation = annotation as? SpotMapImageAnnotation else {
            return nil
        }

        let annotationView: SpotMapImageAnnotationView
        switch mapView.dequeueReusableAnnotationView(withIdentifier: SpotMapImageAnnotationView.reuseIdentifier) as? SpotMapImageAnnotationView {
        case nil:
            annotationView = SpotMapImageAnnotationView(annotation: annotation, reuseIdentifier: SpotMapImageAnnotationView.reuseIdentifier)
        case let _annotationView?:
            annotationView = _annotationView
            annotationView.annotation = annotation
        }

        annotationView.translatesAutoresizingMaskIntoConstraints = false
        annotationView.setup(spotMapImage: self.mapView.annotationContent(annotation.fragment))
        return annotationView
    }
}
