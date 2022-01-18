import Foundation
import SwiftUI

struct SpotMapAccountIcon: View {
    @Environment(\.me) var me

    @StateObject var watch = Watch<SpotMapIconQuery>()

    @State var user: SpotMapIconQuery.Data.Me.User?

    var body: some View {
        NavigationLink {
            AccountPage()
        } label: {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                case _:
                    Image(systemName: "person.crop.circle")
                        .resizable()
                }
            }
            .frame(width: 44, height: 44)
        }
        .task {
            for await data in watch(for: .init()) {
                user = data.me.user
            }
        }
    }

    private var imageURL: URL? {
        user?.resizedProfileImageUrLs.thumbnail ?? user?.profileImageUrl
    }
}
