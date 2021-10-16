import Foundation
import SwiftUI
import Apollo

public struct SpotDetailPage: View {
    @Environment(\.dismiss) var dismiss

    let spotID: String

    public var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        SpotPostImage(
                            width: geometry.size.width,
                            image: image,
                            takenPhoto: takenPhoto,
                            selectedPhoto: selectedPhoto
                        )
                        SpotPostTitle(title: $title)
                        if image != nil {
                            SpotPostGeoPoint(place: $placemark)
                        }
                        Spacer()

                        SpotPostSubmitButton(image: image, title: title, placemark: placemark, dismiss: dismiss)
                    }
                    .padding(.vertical, 24)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .background(Color.screenBackground.edgesIgnoringSafeArea(.all))
            .navigationBarItems(
                leading: Button(action: dismiss.callAsFunction, label: {
                    Image(systemName: "xmark")
                        .renderingMode(.template)
                        .foregroundColor(.appPrimary)
                })
            )
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}
