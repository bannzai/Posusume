import MapKit

final class ClusterAnnotationView: MKAnnotationView {
    static let reuseIdentifier = "ClusterAnnotationView"
    let spotCountLabel = UILabel()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        collisionMode = .circle
        canShowCallout = false

        addSubview(spotCountLabel)
        spotCountLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            spotCountLabel.topAnchor.constraint(equalTo: topAnchor),
            spotCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            spotCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            spotCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        if let cluster = annotation as? MKClusterAnnotation {
            let spotAnnotations = cluster.memberAnnotations.compactMap { $0 as? SpotMapImageAnnotation }
            let spotCount = spotAnnotations.count

            spotCountLabel.text = "\(spotCount)"
        }
    }
}


