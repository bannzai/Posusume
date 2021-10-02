import SwiftUI
import Combine
import CoreLocation
import PhotosUI
import Photos
import MapKit
import FirebaseStorageSwift

struct SpotPostView: View {
    @State var title: String?
    @State var imageName: String?
    @State var image: UIImage?
    @StateObject var mutation = Mutation<SpotAddMutation>()

    var body: some View {
        EmptyView()
    }
//    var body: some View {
//        NavigationView {
//            ZStack(alignment: .top) {
//                Color.screenBackground.edgesIgnoringSafeArea(.all)
//                ScrollView(showsIndicators: false) {
//                    VStack(spacing: 18) {
//                        Spacer().frame(height: 16)
//                        Button (action: {
//                            viewStore.send(.presentImageSelectActionSheet)
//                        },
//                        label: {
//                            if let image = viewStore.state.viewState.image {
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .frame(width: UIScreen.main.bounds.width - 40)
//                                    .aspectRatio(3 / 4, contentMode: .fit)
//                                    .clipped()
//                                    .padding(.horizontal, 20)
//                            } else {
//                                VStack {
//                                    Image("anyPicture")
//                                        .resizable()
//                                        .renderingMode(.template)
//                                        .aspectRatio(contentMode: .fit)
//                                        .frame(width: 40, height: 40)
//                                    Text("画像を選択")
//                                        .font(.footnote)
//                                }
//                                .foregroundColor(.placeholder)
//                                .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 160)
//                                .background(Color.white)
//                                .padding(.horizontal, 20)
//                            }
//                        })
//                        .buttonStyle(PlainButtonStyle())
//
//                        VStack(alignment: .leading) {
//                            Text("タイトル")
//                                .font(.subheadline)
//                            TextField("ポスターのタイトル", text: viewStore.binding(get: \.viewState.title, send: SpotPostAction.edited(title:)))
//                                .font(.caption)
//                                .textFieldStyle(PlainTextFieldStyle())
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 14)
//                                .padding(.horizontal, 16)
//                                .background(Color.white)
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.leading, 20)
//
//                        VStack(alignment: .leading) {
//                            Button(
//                                action: {
//                                    if !viewStore.viewState.canEditGeoPoint {
//                                        return
//                                    }
//                                    viewStore.send(.presentLocationSelect)
//                                },
//                                label: {
//                                    if let geoPoint = viewStore.viewState.geoPoint {
//                                        Text("画像を撮った場所を選んでください")
//                                            .font(.subheadline)
//                                    } else {
//                                        Text("画像を撮った場所を選んでください")
//                                            .font(.subheadline)
//                                    }
//                                }
//                            )
//                            .frame(height: 80)
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.leading, 20)
//
//                        Spacer()
//
//                        Button(action: {
//
//                        },
//                        label: {
//                            Text("保存")
//                                .foregroundColor(.white)
//                                .font(.body)
//                                .fontWeight(.medium)
//                        })
//                        .disabled(viewStore.viewState.submitButtonIsDisabled)
//                        .frame(width: 200, height: 44, alignment: .center)
//                        .background(viewStore.viewState.submitButtonIsDisabled ? Color.disabled.gradient : GradientColor.barn)
//
//                        Spacer().frame(height: 32)
//                    }
//                }
//            }
//            .navigationBarItems(
//                leading:
//                    Button(action: {
//                        viewStore.send(.dismiss)
//                    }) {
//                        Image(systemName: "xmark")
//                            .renderingMode(.template)
//                            .foregroundColor(.appPrimary)
//                    }
//            )
//            .navigationBarTitle("", displayMode: .inline)
//        }
//        .actionSheet(
//            isPresented: viewStore.binding(
//                get: \.isPresentedImageSelectionActionSheet,
//                send: { _ in .dismissedImageSelectActionSheet }
//            ),
//            content: {
//                ActionSheet(
//                    title: Text("写真を1枚選んでください"),
//                    buttons: [
//                        .default(Text("撮影する"), action: {
//                            viewStore.send(.presentPhotoCamera)
//                        }),
//                        .default(Text("写真から選択"), action: {
//                            viewStore.send(.presentPhotoLibrary)
//                        }),
//                        .cancel(Text("キャンセル"), action: {
//
//                        })
//                    ]
//                )
//            }
//        )
//        .sheet(
//            item: viewStore.binding(
//                get: \.presentationType,
//                send: { .presentationTypeDidChanged($0) }
//            ),
//            content: { type -> AnyView in
//                switch type {
//                case .camera:
//                    return AnyView(
//                        PhotoCameraViewConnector(
//                            store: store.scope(
//                                state: \.photoCamera,
//                                action: { .photoCameraAction($0)}
//                            )
//                        )
//                    )
//                case .photoLibrary:
//                    return AnyView(
//                        PhotoLibraryViewConnector(
//                            store: store.scope(
//                                state: \.photoLibrary,
//                                action: { .photoLibraryAction($0) }
//                            )
//                        )
//                    )
//                case .locationSelection:
//                    return AnyView(
//                        LocationSelectView(
//                            store: store.scope(
//                                state: \.locationSelect,
//                                action: { .locationSelectAction($0) }
//                            )
//                        )
//                    )
//                case .openSettingAlert:
//                    return AnyView(EmptyView())
//                case .notPermissionAlert:
//                    return AnyView(EmptyView())
//                }
//            }
//        )
//    }
    
}

struct SpotListView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SpotPostView()
        }
    }
}
