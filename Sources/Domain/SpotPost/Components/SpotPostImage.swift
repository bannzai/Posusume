import Foundation
import SwiftUI

struct SpotPostImage: View {
    @Environment(\.geocoder) var geocoder

    @State var showsActionSheet: Bool = false
    @State var error: Error?
    @State var isPresentingEditor = false

    let width: CGFloat
    let image: UIImage?
    let takenPhoto: ((UIImage) -> Void)
    let selectedPhoto: (PhotoLibraryResult) -> Void
    @Binding var edtiroState: SpotPostEditorPageState

    var body: some View {
        Button (
            action: {
                showsActionSheet = true
            },
            label: {
                ZStack(alignment: .topTrailing) {
                    Group {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                        } else {
                            VStack {
                                Spacer()
                                Image("anyPicture")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                Text("画像を選択")
                                    .font(.footnote)
                                Spacer()
                            }
                            .foregroundColor(.placeholder)
                        }
                    }
                    .spotImageFrame(width: width)
                    .background(Color.white)

                    if let image = image {
                        Button(action: {
                            isPresentingEditor = true
                        }, label: {
                            Image(systemName: "pencil.and.outline")
                                .foregroundColor(Color.black)
                                .frame(width: 22, height: 22)
                                .padding(.all, 4)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        }).sheet(isPresented: $isPresentingEditor) {
                            SpotPostEditorPage(image: image, state: $edtiroState)
                        }
                        .padding([.top, .trailing], 12)
                    }
                }
            })
            .buttonStyle(PlainButtonStyle())
            .clipped()
            .adaptImagePickEvent(
                showsActionSheet: $showsActionSheet,
                error: $error,
                takenPhoto: takenPhoto,
                selectedPhoto: selectedPhoto
            )
            .handle(error: $error)
    }
}


private struct Preview: PreviewProvider {
    @State static var edtiroState: SpotPostEditorPageState = .init()
    static var previews: some View {
        SpotPostImage(width: UIScreen.main.bounds.width - 40, image: nil, takenPhoto: { _ in }, selectedPhoto: { _ in }, edtiroState: $edtiroState)
    }
}
