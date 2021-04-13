import SwiftUI
import MapKit
import ComposableArchitecture
import Combine

struct RootState: Equatable {
    var spots: [Spot] = []
    var error: EquatableError?
}

enum RootAction: Equatable {
    case onAppear
    case fetch
    case fetched(Result<[Spot], EquatableError>)
}

struct RootEnvironment {
    let auth: Auth
    let fetchList: (DatabaseCollectionPathBuilder<Spot>) -> AnyPublisher<[Spot], Error>
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

struct RootView: View {

    var body: some View {
        EmptyView()
            .edgesIgnoringSafeArea(.all)
    }
}



struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
