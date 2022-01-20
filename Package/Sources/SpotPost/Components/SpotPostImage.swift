import Foundation
import SwiftUI
import Photo
import SpotPostEditor

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
    @Binding var editingSnapshot: UIImage?

    var body: some View {
        Button (
            action: {
                showsActionSheet = true
            },
            label: {
                ZStack(alignment: .topTrailing) {
                    if let image = editingSnapshot {
                        Image(uiImage: image)
                    } else if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .spotImageFrame(width: width)
                    } else {
                        VStack {
                            Spacer()
                            Image(systemName: "photo")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            Text("画像を選択")
                                .font(.footnote)
                            Spacer()
                        }
                        .foregroundColor(.placeholder)
                        .spotImageFrame(width: width)
                        .background(Color.white)
                    }

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
                            SpotPostEditorPage(state: $edtiroState, image: image, snapshotOnDisappear: { spotPostEditorImage in
                                editingSnapshot = spotPostEditorImage.snapshot()
                            })
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
    static var previews: some View {
        SpotPostImage(width: UIScreen.main.bounds.width - 40, image: nil, takenPhoto: { _ in }, selectedPhoto: { _ in }, edtiroState: .constant(.init()), editingSnapshot: .constant(nil))
    }
}
