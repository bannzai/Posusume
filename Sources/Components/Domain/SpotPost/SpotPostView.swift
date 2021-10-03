import SwiftUI
import Combine
import CoreLocation
import PhotosUI
import Photos
import MapKit
import FirebaseStorageSwift

struct SpotPostView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var upload = Upload()
    @StateObject var mutation = Mutation<SpotAddMutation>()

    @State var image: UIImage?
    @State var title: String = ""
    @State var geoPoint: CLLocationCoordinate2D?

    var submitButtonIsDisabled: Bool {
        image == nil || title.isEmpty
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color.screenBackground.edgesIgnoringSafeArea(.all)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        SpotPostImageView(image: $image)
                        VStack(alignment: .leading) {
                            Text("タイトル")
                                .font(.subheadline)
                            TextField("ポスターのタイトル", text: $title)
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
                                    // TODO:
                                },
                                label: {
                                    if let geoPoint = geoPoint {
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

                        Button(
                            action: {
                                // TODO:
                            },
                            label: {
                                Text("保存")
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .fontWeight(.medium)
                            })
                            .disabled(submitButtonIsDisabled)
                            .frame(width: 200, height: 44, alignment: .center)
                            .background(submitButtonIsDisabled ? Color.disabled.gradient : GradientColor.barn
                            )

                        Spacer().frame(height: 32)
                    }
                }
            }
            .padding(.vertical, 16)
            .navigationBarItems(
                leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .foregroundColor(.appPrimary)
                    }
            )
            .navigationBarTitle("", displayMode: .inline)
        }
    }
    
}

struct SpotListView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SpotPostView()
        }
    }
}
