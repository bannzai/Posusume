import SwiftUI

struct BarnBottomSheet: View {
    static let height: CGFloat = 300
    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(
                gradient: Gradient(colors: [.barnEnd, Color.barnEnd.opacity(0.01)]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(width: UIScreen.main.bounds.width, height: BarnBottomSheet.height * 0.3)

            LinearGradient(
                gradient: Gradient(colors: [.barnStart, Color.barnEnd]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(width: UIScreen.main.bounds.width, height: BarnBottomSheet.height * 0.7)
        }
    }
}

struct BarnBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BarnBottomSheet()
            .previewLayout(.sizeThatFits)
    }
}
