import SwiftUI
import Combine
import ComposableArchitecture
import MapKit
import CoreLocation

struct LocationSearchState: Equatable {
    var searchText: String = ""
    var marks: [PlaceMark] = []
}

enum LocationSearchAction: Equatable {
    case search(String)
    case searched(Result<[PlaceMark], EquatableError>)
}

struct LocationSearchEnvironment {
    let geocoder: Geocoder
}

let locationSearchReducer: Reducer<LocationSearchState, LocationSearchAction, LocationSearchEnvironment> = .init { state, action, environment in
    switch action {
    case let .search(text):
        state.searchText = text
        return Effect(environment.geocoder.geocoder(address: text))
            .mapError(EquatableError.init(error:))
            .catchToEffect()
            .map(LocationSearchAction.searched)
            .eraseToEffect()
    case let .searched(.success(marks)):
        state.marks = []
        return .none
    case .searched(.failure):
        state.marks = []
        return .none
    }
}

struct LocationSearchView: View {
    let store: Store<LocationSearchState, LocationSearchAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVStack {
                    Section(header: Text("Header")) {
                        SearchBar(
                            isEditing: true,
                            text: viewStore.binding(
                                get: \.searchText,
                                send: {
                                    .search($0)
                                }
                            )
                        )
                    }
                    ForEach(0..<viewStore.marks.count) { i in
                        HStack {
                            Text(formatForLocation(mark: viewStore.marks[i]))
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

func formatForLocation(mark: PlaceMark) -> String {
    if !mark.name.isEmpty {
        return "\(mark.name): \(mark.address.address)"
    }
    return mark.address.address
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(
            store: .init(
                initialState: .init(),
                reducer: locationSearchReducer,
                environment: LocationSearchEnvironment(
                    geocoder: geocoder
                )
            )
        )
    }
}
