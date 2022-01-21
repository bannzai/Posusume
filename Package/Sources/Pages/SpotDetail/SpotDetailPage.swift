import Foundation
import SwiftUI
import Apollo
import MapKit
import GraphQL
import Components

public struct SpotDetailPage: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var query = Query<SpotQuery>()

    @State var response: SpotQuery.Data?
    @State var error: Error?

    let spotID: String

    public init(spotID: String) {
        self.spotID = spotID
    }

    public var body: some View {
        Loading(value: response) { response in
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack {
                        SpotDetailImage(
                            width: geometry.size.width,
                            fragment: response.spot.fragments.spotDetailImageFragment
                        )

                        Spacer(minLength: 20)
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationBarItems(
                leading: Button(action: dismiss.callAsFunction, label: {
                    Image(systemName: "xmark")
                        .renderingMode(.template)
                        .foregroundColor(.appPrimary)
                })
            )
            .navigationBarTitle(response.spot.title, displayMode: .inline)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .background(Color.screenBackground.edgesIgnoringSafeArea(.all))
        .task {
            if let response = await query.cache(for: .init(spotId: spotID)) {
                self.response = response
            }

            do {
                response = try await query(for: .init(spotId: spotID))
            } catch {
                self.error = error
            }
        }
        .handle(error: $error)
    }

}

