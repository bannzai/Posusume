import SwiftUI
import Combine
import ComposableArchitecture
import MapKit
import CoreLocation

struct LocationSelectState: Equatable {
    var searchText: String = ""
    var marks: [PlaceMark] = []
    var selected: PlaceMark? = nil
}

enum LocationSelectAction: Equatable {
    case search(String)
    case searched(Result<[PlaceMark], EquatableError>)
    case selected(PlaceMark)
}

struct LocationSelectEnvironment {
    let geocoder: Geocoder
}

let locationSelectReducer: Reducer<LocationSelectState, LocationSelectAction, LocationSelectEnvironment> = .init { state, action, environment in
    switch action {
    case let .search(text):
        state.searchText = text
        return Effect(environment.geocoder.geocoder(address: text))
            .mapError(EquatableError.init(error:))
            .catchToEffect()
            .map(LocationSelectAction.searched)
            .eraseToEffect()
    case let .searched(.success(marks)):
        state.marks = []
        return .none
    case .searched(.failure):
        state.marks = []
        return .none
    case let .selected(mark):
        state.selected = mark
        return .none
    }
}

struct LocationSelectView: View {
    let store: Store<LocationSelectState, LocationSelectAction>
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
                                .onTapGesture {
                                    viewStore.send(.selected(viewStore.marks[i]))
                                }
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

struct LocationSelectView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelectView(
            store: .init(
                initialState: .init(),
                reducer: locationSelectReducer,
                environment: LocationSelectEnvironment(
                    geocoder: geocoder
                )
            )
        )
    }
}
