import Foundation
import SwiftUI

public struct SpotImageFrameModifier: ViewModifier {
    // NOTE: The size of the ScrollView will not be determined unless the size of the child(SpotPostImage) element is determined. `width` for determining the child size
    // And it is difficult to use GeometryReader inside ScrollView
    // See also: https://stackoverflow.com/questions/58965503/geometryreader-in-swiftui-scrollview-causes-weird-behaviour-and-random-offset
    let edge: Edge
    public func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: width, height: height)
    }

    private var width: CGFloat {
        switch edge {
        case let .width(width):
            return width
        case let .height(height):
            return height / 7 * 5
        }
    }

    private var height: CGFloat {
        switch edge {
        case let .width(width):
            return width / 5 * 7
        case let .height(height):
            return height
        }
    }

    enum Edge {
        case width(CGFloat)
        case height(CGFloat)
    }
}

extension View {
    public func spotImageFrame(width: CGFloat) -> some View {
        modifier(SpotImageFrameModifier(edge: .width(width)))
    }
    public func spotImageFrame(height: CGFloat) -> some View {
        modifier(SpotImageFrameModifier(edge: .height(height)))
    }
}
