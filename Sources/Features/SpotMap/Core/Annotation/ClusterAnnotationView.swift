import MapKit

final class ClusterAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        if let cluster = annotation as? MKClusterAnnotation {
            let totalBikes = cluster.memberAnnotations.count

            

            if count(cycleType: .unicycle) > 0 {
                image = drawUnicycleCount(count: totalBikes)
            } else {
                let tricycleCount = count(cycleType: .tricycle)
                image = drawRatioBicycleToTricycle(tricycleCount, to: totalBikes)
            }

            if count(cycleType: .unicycle) > 0 {
                displayPriority = .defaultLow
            } else {
                displayPriority = .defaultHigh
            }
        }
    }
}


