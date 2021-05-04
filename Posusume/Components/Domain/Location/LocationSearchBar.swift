import SwiftUI
import CoreLocation

struct LocationSearchBar: View {
    @State var text: String = ""
    @State var isPresented: Bool = false
    var body: some View {
        SearchBar(text: $text, isDisableAutocorrection: true)
            .onTapGesture {
                self.isPresented = true
            }
            .sheet(isPresented: $isPresented, content: {
                LocationSearchView(
                    store: .init(
                        initialState: .init(),
                        reducer: locationSearchReducer,
                        environment: LocationSearchEnvironment(geocoder: geocoder)))
            })
    }
}

struct LocationSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchBar()
    }
}
