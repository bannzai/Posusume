import SwiftUI
import MapKit
import ComposableArchitecture
import Combine

struct LoginState: Equatable {
    var me: Me? = nil
    var error: EquatableError? = nil
}

enum LoginAction: Equatable {
    case auth
    case authorized(Result<Me, EquatableError>)
    case prepareUser(Me)
    case preparedUser(Result<User, EquatableError>)
    case endLogin(Me)
}

struct LoginEnvironment {
    let auth: Auth
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let createOrUpdateUser: (DatabaseCollectionPathBuilder<User>, User, String) -> AnyPublisher<User, Error>
}

let loginReducer: Reducer<LoginState, LoginAction, LoginEnvironment> = .init { state, action, environment in
    switch action {
    case .auth:
        return environment.auth
            .auth()
            .mapError(EquatableError.init(error:))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(LoginAction.authorized)
    case let .authorized(.success(me)):
        state.me = me
        return Effect(value: .prepareUser(me))
    case let .authorized(.failure(error)):
        state.error = error
        return .none
    case let .prepareUser(me):
        return environment
            .createOrUpdateUser(.users(), User(id: me.userID, anonymousUserID: me.userID), me.userID.rawValue)
            .mapError(EquatableError.init(error:))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(LoginAction.preparedUser)
    case let .preparedUser(.success(user)):
        return Effect(value: .endLogin(Me(id: Me.ID(rawValue: user.anonymousUserID.rawValue))))
    case let .preparedUser(.failure(error)):
        state.error = error
        return .none
    case let .endLogin(me):
        return .none
    }
}

struct LoginView: View {
    let store: Store<LoginState, LoginAction>
    @State var region: MKCoordinateRegion = defaultRegion
    var body: some View {
        // NOTE: Currently Posusume provided only anonymous login. It means about LoginView only keep empty map view until authorized
        WithViewStore(store) { viewStore in
            Map(coordinateRegion: $region)
                .onAppear(perform: { viewStore.send(.auth) })

        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: .init(
                initialState: .init(),
                reducer: loginReducer,
                environment: LoginEnvironment(
                    auth: MockAuth(),
                    mainQueue: .main,
                    createOrUpdateUser: { (path, user, identifier) -> AnyPublisher<User, Error> in
                        Future(value: user).eraseToAnyPublisher()
                    }
                )
            )
        )
    }
}
