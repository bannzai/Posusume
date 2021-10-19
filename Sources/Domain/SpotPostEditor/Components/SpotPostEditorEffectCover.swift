import Foundation
import SwiftUI

struct SpotPostEditorEffectCover: View {
    @Binding var elements: [SpotPostEditorEffectCoverElement]

    var body: some View {
        ZStack {
            ForEach(elements) { element in
                Element(text: element.text)
            }
        }
    }
}

struct Element: View {
    let text: String

    @State private var location: CGPoint = CGPoint(x: 50, y: 50)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil

    var body: some View {
        Text(text)
            .font(.title)
            .position(location)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        var newLocation = startLocation ?? location
                        newLocation.x += value.translation.width
                        newLocation.y += value.translation.height
                        location = newLocation
                    }.updating($startLocation) { (value, startLocation, transaction) in
                        startLocation = startLocation ?? location
                    }
            )
    }
}

struct SpotPostEditorEffectCoverElement: Identifiable {
    let id: UUID = .init()
    let text: String
}


struct SpotPostEditorEffectCover_Previews: PreviewProvider {
    @State static var elements: [SpotPostEditorEffectCoverElement] = [.init(text: "Hello, world")]
    static var previews: some View {
        SpotPostEditorEffectCover(elements: $elements)
    }
}
