import Foundation
import SwiftUI
import MapKit

public struct SpotMapKitMapView: UIViewRepresentable {
    public typealias UIViewType = MKMapView

    @Binding var coordinateRegion: MKCoordinateRegion
    let annotationItems: [SpotMapImageFragment]
    let annotationContent: (SpotMapImageFragment) -> (SpotMapImage)

    public func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.delegate = context.coordinator
        view.isZoomEnabled = true
        view.isScrollEnabled = true
        view.isPitchEnabled = true
        view.isRotateEnabled = true
        view.showsBuildings = true
        view.mapType = .standard
        view.userTrackingMode = .follow
        view.showsUserLocation = true
        view.showsCompass = false

        view.register(SpotMapImageAnnotationView.self, forAnnotationViewWithReuseIdentifier: SpotMapImageAnnotationView.reuseIdentifier)

        view.addAnnotations(annotationItems.map(SpotMapImageAnnotation.init))

        return view
    }

    public func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.region = coordinateRegion

        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotationItems.map(SpotMapImageAnnotation.init))
    }

    public class Coordinator: NSObject {
        var mapView: SpotMapKitMapView

        init(mapView: SpotMapKitMapView) {
            self.mapView = mapView
        }
    }

    public func makeCoordinator() -> Coordinator {
        .init(mapView: self)
    }
}


extension SpotMapKitMapView.Coordinator: MKMapViewDelegate {
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
        }

        annotationView.annotation = annotation
        annotationView.frame.size =  .init(width: 48, height: 48)
        annotationView.setup(spotMapImage: self.mapView.annotationContent(annotation.fragment))
        return annotationView
    }

    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped")

        mapView.clearSelection()
    }
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
       self.mapView.coordinateRegion = mapView.region

        mapView.clearSelection()
    }
}

extension MKMapView {
    // NOTE: AnnotationView should clear if want to enable touch again
    func clearSelection() {
        selectedAnnotations.forEach {
            deselectAnnotation($0, animated: false)
        }
    }
}
