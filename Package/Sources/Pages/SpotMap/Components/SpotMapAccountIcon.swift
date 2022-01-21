import Foundation
import SwiftUI
import GraphQL
import Components
import Account

struct SpotMapAccountIcon: View {
    @StateObject var watch = Watch<SpotMapIconQuery>()

    @State var user: SpotMapIconQuery.Data.Me.User?

    var body: some View {
        NavigationLink {
            AccountPage()
        } label: {
            ProfileImage(fragment: user?.fragments.profileImageFragment)
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
