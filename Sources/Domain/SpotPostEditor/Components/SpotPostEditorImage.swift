import Foundation
import SwiftUI

struct SpotPostEditorImage: View {
    let image: UIImage
    @State private var currentMagnification: CGFloat = 1
    @GestureState private var pinchMagnification: CGFloat = 1

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .scaleEffect(currentMagnification * pinchMagnification)
            .gesture(magnification)
    }

    private var magnification: some Gesture {
        MagnificationGesture()
            .onEnded { value in
                currentMagnification *= value
            }
            .updating($pinchMagnification) { (currentState, pinchMagnification, transaction) in
                pinchMagnification = currentState
            }
    }
}

