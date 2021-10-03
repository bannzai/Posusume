import SwiftUI
import Combine
import CoreLocation
import PhotosUI
import Photos
import MapKit
import FirebaseStorageSwift

struct SpotPostView: View {
    @StateObject var upload = Upload()
    @StateObject var mutation = Mutation<SpotAddMutation>()

    @State var title: String?
    @State var imageName: String?
    @State var image: UIImage?

    var body: some View {
        EmptyView()
    }
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color.screenBackground.edgesIgnoringSafeArea(.all)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        SpotPostImageView()
                        VStack(alignment: .leading) {
                            Text("タイトル")
                                .font(.subheadline)
                            TextField("ポスターのタイトル", text: viewStore.binding(get: \.viewState.title, send: SpotPostAction.edited(title:)))
                                .font(.caption)
                                .textFieldStyle(PlainTextFieldStyle())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 16)
                                .background(Color.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 20)

                        VStack(alignment: .leading) {
                            Button(
                                action: {
                                    if !viewStore.viewState.canEditGeoPoint {
                                        return
                                    }
                                    viewStore.send(.presentLocationSelect)
                                },
                                label: {
                                    if let geoPoint = viewStore.viewState.geoPoint {
                                        Text("画像を撮った場所を選んでください")
                                            .font(.subheadline)
                                    } else {
                                        Text("画像を撮った場所を選んでください")
                                            .font(.subheadline)
                                    }
                                }
                            )
                            .frame(height: 80)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 20)

                        Spacer()

                        Button(action: {

                        },
                        label: {
                            Text("保存")
                                .foregroundColor(.white)
                                .font(.body)
                                .fontWeight(.medium)
                        })
                        .disabled(viewStore.viewState.submitButtonIsDisabled)
                        .frame(width: 200, height: 44, alignment: .center)
                        .background(viewStore.viewState.submitButtonIsDisabled ? Color.disabled.gradient : GradientColor.barn)

                        Spacer().frame(height: 32)
                    }
                }
            }
            .padding(.vertical: 16)
            .navigationBarItems(
                leading:
                    Button(action: {
                        viewStore.send(.dismiss)
                    }) {
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .foregroundColor(.appPrimary)
                    }
            )
            .navigationBarTitle("", displayMode: .inline)
        }
        .sheet(
            item: viewStore.binding(
                get: \.presentationType,
                send: { .presentationTypeDidChanged($0) }
            ),
            content: { type -> AnyView in
                switch type {
                case .camera:
                    return AnyView(
                        PhotoCameraViewConnector(
                            store: store.scope(
                                state: \.photoCamera,
                                action: { .photoCameraAction($0)}
                            )
                        )
                    )
                case .photoLibrary:
                    return AnyView(
                        PhotoLibraryViewConnector(
                            store: store.scope(
                                state: \.photoLibrary,
                                action: { .photoLibraryAction($0) }
                            )
                        )
                    )
                case .locationSelection:
                    return AnyView(
                        LocationSelectView(
                            store: store.scope(
                                state: \.locationSelect,
                                action: { .locationSelectAction($0) }
                            )
                        )
                    )
                case .openSettingAlert:
                    return AnyView(EmptyView())
                case .notPermissionAlert:
                    return AnyView(EmptyView())
                }
            }
        )
    }
    
}

struct SpotListView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SpotPostView()
        }
    }
}
