import SwiftUI

struct BarnBottomSheet: View {
    static let height: CGFloat = 270
    var body: some View {
        VStack(spacing: 0) {
            GradientColor
                .upper
                .frame(width: UIScreen.main.bounds.width, height: BarnBottomSheet.height * 0.3)

            GradientColor
                .lower
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
