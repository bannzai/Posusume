import SwiftUI
import ComposableArchitecture
import Combine
import CoreLocation
import FirebaseFirestore

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
            self.viewState = .init(location: point, name: "", imageFileName: "")
            self.isNew = true
        case let .update(spot):
            self.viewState = spot
            self.isNew = false
        }
    }
    
    var error: EquatableError? = nil
    var shouldDismiss: Bool = false
}

enum SpotPostAction: Equatable {
    case post
    case create
    case update
    case posted(Result<Spot, EquatableError>)
    case dismiss
}

struct SpotPostEnvironment {
    let me: Me
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let create: (DatabaseCollectionPathBuilder<Spot>) -> (AnyPublisher<Spot, Error>)
    let update: (DatabaseCollectionPathBuilder<Spot>, Spot, String) -> (AnyPublisher<Spot, Error>)
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
        return Effect(value: .dismiss)
    case .posted(.failure(let error)):
        state.error = error
        return .none
    case .dismiss:
        state.shouldDismiss = true
        return .none
    }
}


struct SpotPostView: View {
    @State var text: String = ""
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color.screenBackground.edgesIgnoringSafeArea(.all)
                VStack(spacing: 18) {
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
                    
                    VStack(alignment: .leading) {
                        Text("タイトル")
                            .font(.subheadline)
                        TextField("ポスターのタイトル", text: $text)
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

                    }) {
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .foregroundColor(.appPrimary)
                    }
            )
        }
    }
    
}

struct SpotListView_Preview: PreviewProvider {
    static var previews: some View {
        SpotPostView()
    }
}
