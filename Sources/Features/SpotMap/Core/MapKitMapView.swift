import Foundation
import SwiftUI
import MapKit

public struct MapKitMapView: UIViewRepresentable {
    public typealias UIViewType = MKMapView

    public func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.delegate = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: MKMapView, context: Context) {

    }

    public class Coordinator: NSObject, MKMapViewDelegate {
        let view: MapKitMapView

        init(view: MapKitMapView) {
            self.view = view
        }
    }

    public func makeCoordinator() -> Coordinator {
        .init(view: self)
    }
}



