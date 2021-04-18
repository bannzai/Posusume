import SwiftUI
import ComposableArchitecture
import Combine
import CoreLocation
import FirebaseFirestore
import PhotosUI
import Photos

struct SpotPostState: Equatable {
    enum Context {
        case create(GeoPoint)
        case update(Spot)
    }

    var viewState: Spot
    let isNew: Bool
    init(context: Context) {
        switch context {
        case let .create(point):
            self.viewState = .init(location: point, title: "", imageFileName: "")
            self.isNew = true
        case let .update(spot):
            self.viewState = spot
            self.isNew = false
        }
    }
    
    var error: EquatableError? = nil
    var isPresentOpenSettingAppAlert: Bool = false
    var isPresentNotPermissionAlert: Bool = false
}

enum SpotPostAction: Equatable {
    case post
    case create
    case update
    case posted(Result<Spot, EquatableError>)
    case dismiss
    case edited(title: String)
    case prepare
    case authorized(Result<PHAuthorizationStatus, Never>)
    case presentOpenSettingAlert
    case presentedOpenSetting
    case presentNotPermissionAlert
    case openSetting
    case confirmedNotPermission
    case cancelAlertAction
}

struct SpotPostEnvironment {
    let me: Me
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let create: (DatabaseCollectionPathBuilder<Spot>) -> (AnyPublisher<Spot, Error>)
    let update: (DatabaseCollectionPathBuilder<Spot>, Spot, String) -> (AnyPublisher<Spot, Error>)
    let photoLibrary: PhotoLibrary
}

let spotPostReducer: Reducer<SpotPostState, SpotPostAction, SpotPostEnvironment> = .init { state, action, environment in
    switch action {
    case .post:
        return state.isNew ? Effect(value: .create) : Effect(value: .update)
    case .create:
        return environment.create(.userSpots(userID: environment.me.userID))
            .mapError(EquatableError.init(error:))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(SpotPostAction.posted)
    case .update:
        guard let identifier = state.viewState.id?.rawValue else {
            fatalError("unexpected state.viewState.id is nil when post -> update. \(state)")
        }
        return environment.update(.userSpots(userID: environment.me.userID), state.viewState, identifier)
            .mapError(EquatableError.init(error:))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(SpotPostAction.posted)
    case .posted(.success(let spot)):
        state.error = nil
        return Effect(value: .dismiss)
    case .posted(.failure(let error)):
        state.error = error
        return .none
    case .dismiss:
        return .none
    case let .edited(title):
        state.viewState.title = title
        return .none
    case .prepare:
        switch environment.photoLibrary.prepareActionType() {
        case nil:
            return .none
        case .openSettingApp:
            return Effect(value: .presentOpenSettingAlert)
        case .requestAuthorization:
            return environment
                .photoLibrary
                .requestAuthorization()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SpotPostAction.authorized)
        }
    case let .authorized(.success(status)):
        switch status {
        case .authorized:
            return .none
        case .limited:
            return .none
        case .notDetermined:
            return Effect(value: .presentNotPermissionAlert)
        case .denied:
            return Effect(value: .presentNotPermissionAlert)
        case .restricted:
            return Effect(value: .presentNotPermissionAlert)
        @unknown default:
            assertionFailure("unexpected authorization status \(status):\(status.rawValue)")
            return .none
        }
    case .presentOpenSettingAlert:
        state.isPresentOpenSettingAppAlert = true
        return .none
    case .openSetting:
        guard UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) else {
            assertionFailure("unexpected cannot open setting apps")
            return .none
        }
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        return Effect(value: .presentedOpenSetting)
    case .presentedOpenSetting:
        state.isPresentOpenSettingAppAlert = false
        return .none
    case .presentNotPermissionAlert:
        state.isPresentNotPermissionAlert = true
        return .none
    case .confirmedNotPermission:
        state.isPresentNotPermissionAlert = false
        return .none
    case .cancelAlertAction:
        state.isPresentOpenSettingAppAlert = false
        state.isPresentNotPermissionAlert = false
        return .none
    }
}


struct SpotPostView: View {
    let store: Store<SpotPostState, SpotPostAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ZStack(alignment: .top) {
                    Color.screenBackground.edgesIgnoringSafeArea(.all)
                    VStack(spacing: 18) {
                        Button (action: {
                            
                        },
                        label: {
                            VStack {
                                Image("anyPicture")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                Text("画像を選択")
                                    .font(.footnote)
                            }
                            .foregroundColor(.placeholder)
                            .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 160)
                            .background(Color.white)
                            .padding(.horizontal, 20)
                        })

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
                    }
                }
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
            }
        }
    }
    
}

struct SpotListView_Preview: PreviewProvider {
    static var previews: some View {
        SpotPostView(
            store: .init(
                initialState: .init(context: .create(spot.location)),
                reducer: spotPostReducer,
                environment: SpotPostEnvironment(
                    me: .init(id: .init(rawValue: "1")),
                    mainQueue: .main,
                    create: { (_) in Future(value: spot).eraseToAnyPublisher() },
                    update: { (_, _, _) in Future(value: spot).eraseToAnyPublisher() },
                    photoLibrary: MockPhotoLibrary()
                )
            )
        )
    }
    static let spot = Spot(location: .init(latitude: 10, longitude: 10), title: "", imageFileName: "")
}
