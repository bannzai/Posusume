import SwiftUI
import Combine
import MapKit
import CoreLocation

struct LocationSelectView: View {
    
    var body: some View {
        EmptyView()
    }

//    var body: some View {
//        WithViewStore(store) { viewStore in
//            VStack(alignment: .leading) {
//                SearchBar(
//                    isEditing: true,
//                    text: viewStore.binding(
//                        get: \.searchText,
//                        send: {
//                            .search($0)
//                        }
//                    )
//                )
//                List {
//                    HStack {
//                        Image(systemName: "location.circle")
//                        Text("現在地を選択")
//                            .font(.headline)
//                            .onTapGesture {
//                                viewStore.send(.selectedCurrentLocationRow)
//                            }
//                    }
//                    ForEach(viewStore.marks) { mark in
//                        HStack {
//                            Text(formatForLocation(mark: mark))
//                                .font(.footnote)
//                                .onTapGesture {
//                                    viewStore.send(.selected(mark))
//                                }
//                        }
//                    }
//                }
//
//            }
//        }
//    }
}

func formatForLocation(mark: PlaceMark) -> String {
    if !mark.name.isEmpty {
        return "\(mark.name): \(mark.address.address)"
    }
    return mark.address.address
}

struct LocationSelectView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LocationSelectView()
                .previewDisplayName("empty search text")
        }
    }
}
