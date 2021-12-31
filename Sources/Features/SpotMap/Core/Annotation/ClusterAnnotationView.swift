import MapKit

final class ClusterAnnotationView: MKAnnotationView {
    static let reuseIdentifier = "ClusterAnnotationView"
    let spotCountLabel = UILabel()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations

        addSubview(spotCountLabel)
        spotCountLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            spotCountLabel.widthAnchor.constraint(equalToConstant: 72),
            spotCountLabel.heightAnchor.constraint(equalToConstant: 101),
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


