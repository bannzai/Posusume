import SwiftUI
import GraphQL

public struct ProfileImage: View {
    let fragment: ProfileImageFragment?

    public init(fragment: ProfileImageFragment?) {
        self.fragment = fragment
    }

    public var body: some View {
        CachedAsyncImage(url: imageURL) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
            case _:
                Image(systemName: "person.crop.circle")
                    .resizable()
            }
        }
    }

    private var imageURL: URL? {
        fragment?.resizedProfileImageUrLs.thumbnail ?? fragment?.profileImageUrl
    }
}

