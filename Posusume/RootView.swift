import SwiftUI
import MapKit
import ComposableArchitecture
import Combine

struct RootState {
    var login: LoginState? = .init()
    var spots: SpotMapState?
    var error: EquatableError?

    mutating func authorized(me: Me) {
        login = nil
        error = nil
        spots = .init()
    }
}

enum RootAction: Equatable {
    case login(LoginAction)
    case spots(SpotMapAction)
}

struct RootEnvironment {
    let auth: Auth
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    loginReducer.optional().pullback(
        state: \.login,
        action: /RootAction.login,
        environment: { root in
            LoginEnvironment(auth: root.auth, mainQueue: root.mainQueue, createOrUpdateUser: FirestoreDatabase.shared.createWithID)
        }
    ),
    spotMapReducer.optional().pullback(
        state: \.spots,
        action: /RootAction.spots,
        environment: { (environment: RootEnvironment) in
            return SpotMapEnvironment(
                me: authorized.authorized(),
                fetchList: FirestoreDatabase.shared.fetchList,
                watchList: FirestoreDatabase.shared.watchList,
                mainQueue: environment.mainQueue
            )
        }
    ),
    .init { (state, action, environment) in
        switch action {
        case .spots:
            return .none
        case let .login(.endLogin(me)):
            state.authorized(me: me)
            return .none
        case .login:
            return .none
        }
    }
)
    


struct RootView: View {
    let store: Store<RootState, RootAction> = .init(
        initialState: .init(),
        reducer: rootReducer,
        environment: RootEnvironment(auth: auth, mainQueue: .main)
    )
    @ViewBuilder public var body: some View {
        IfLetStore(self.store.scope(state: { $0.login }, action: RootAction.login)) { store in
            LoginView(store: store)
        }
        .edgesIgnoringSafeArea(.all)

        IfLetStore(self.store.scope(state: { $0.spots }, action: RootAction.spots)) { store in
            SpotMapView(store: store)
        }
        .edgesIgnoringSafeArea(.all)
    }
}



struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
