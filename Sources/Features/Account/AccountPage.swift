import Foundation
import SwiftUI

public struct AccountPage: View {
    @StateObject var watch = Watch<AccountPageQuery>()

    @State var user: AccountPageQuery.Data.Me.User?
    @State var username: String = ""

    public var body: some View {
        Loading(value: user) { user in
            VStack(alignment: .center, spacing: 10) {
                ProfileImage(fragment: user.fragments.profileImageFragment)
                    .frame(width: 88, height: 88)

                TextField("", text: $username)
                    .multilineTextAlignment(.center)
                    .onSubmit {
                        print("Submit")
                    }
            }
            .navigationTitle(user.name)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            for await data in watch(for: .init()) {
                user = data.me.user
                username = data.me.user.name
            }
        }
    }

    private var profileImageURL: URL? {
        user?.resizedProfileImageUrLs.thumbnail ?? user?.profileImageUrl
    }
}
