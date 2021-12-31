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
    static let reuseIdentifier = "SpotMapImageAnnotationView"
    private var content: UIHostingController<SpotMapImage>?

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        canShowCallout = false
        clusteringIdentifier = "SpotMapImageAnnotationView"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(spotMapImage: SpotMapImage) {
        content?.view.removeFromSuperview()

        let content = UIHostingController(rootView: spotMapImage)
        addSubview(content.view)
        self.content = content
    }
}

