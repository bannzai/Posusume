import Foundation
import MapKit
import SwiftUI
import UIKit

final class SpotMapImageAnnotation: NSObject, MKAnnotation {
    let fragment: SpotMapImageFragment
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0

    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            // For most uses, `coordinate` can be a standard property declaration without the customized getter and setter shown here.
            // The custom getter and setter are needed in this case because of how it loads data from the `Decodable` protocol.
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }

    init(fragment: SpotMapImageFragment) {
        self.fragment = fragment

        super.init()

        coordinate = .init(latitude: fragment.geoPoint.latitude, longitude: fragment.geoPoint.longitude)
    }
}

final class SpotMapImageAnnotationView: MKAnnotationView {
    static let reuseIdentifier = "SpotMapImageAnnotationView"
    private var content: UIHostingController<SpotMapImage>?
    var spotMapImage: SpotMapImage? { content?.rootView }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        canShowCallout = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(spotMapImage: SpotMapImage) {
        content?.view.removeFromSuperview()
        content = nil

        let content = UIHostingController(rootView: spotMapImage)

        addSubview(content.view)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            content.view.widthAnchor.constraint(equalToConstant: 48),
            content.view.heightAnchor.constraint(equalToConstant: 48),
            content.view.centerXAnchor.constraint(equalTo: centerXAnchor),
            content.view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        content.view.backgroundColor = .red
        backgroundColor = .blue

        content.view.setNeedsLayout()
        content.view.layoutIfNeeded()
        self.content = content
    }
}

