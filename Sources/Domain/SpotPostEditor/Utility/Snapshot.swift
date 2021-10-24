import Foundation
import SwiftUI
import UIKit

extension View {
    func snapshot() -> UIImage {
        // NOTE: If it is not Remove status bar and safe area insets,
        // Snapshot contains statusbar and safearea frame as black box frame
        let controller = UIHostingController(rootView: self
                                                        .edgesIgnoringSafeArea(.all)
                                                        .statusBar(hidden: true))

        let targetSize = controller.view.intrinsicContentSize
        controller.view.bounds = CGRect(origin: .zero, size: targetSize)
        controller.view.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: controller.view.bounds.size)

        return renderer.image { context in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
