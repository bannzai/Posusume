import Foundation
import MapKit
import SwiftUI
import UIKit

final class SpotMapImageAnnotation: NSObject, MKAnnotation {
    let fragment: SpotMapImageFragment
    var coordinate: CLLocationCoordinate2D { .init(latitude: fragment.geoPoint.latitude, longitude: fragment.geoPoint.longitude) }

    init(fragment: SpotMapImageFragment) {
        self.fragment = fragment
    }
}


final class SpotMapImageAnnotationView: MKAnnotationView {
    private var content: UIHostingController<SpotMapImage>?

    func setup(spotMapImage: SpotMapImage) {
        content?.view.removeFromSuperview()
        content = .init(rootView: spotMapImage)
    }
}

