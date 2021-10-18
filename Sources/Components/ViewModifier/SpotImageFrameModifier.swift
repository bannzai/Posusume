import Foundation
import SwiftUI

public struct SpotImageFrameModifier: ViewModifier {
    // NOTE: The size of the ScrollView will not be determined unless the size of the child(SpotPostImage) element is determined. `width` for determining the child size
    // And it is difficult to use GeometryReader inside ScrollView
    // See also: https://stackoverflow.com/questions/58965503/geometryreader-in-swiftui-scrollview-causes-weird-behaviour-and-random-offset
    let width: CGFloat
    public func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: width, height: width / 5 * 7)
    }
}

extension View {
    public func spotImageFrame(width: CGFloat) -> some View {
        modifier(SpotImageFrameModifier(width: width))
    }
}
