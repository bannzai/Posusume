import Foundation
import SwiftUI

struct SpotMapAccountIcon: View {
    @Environment(\.me) var me

    var body: some View {
        NavigationLink {
            AccountPage()
        } label: {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 44, height: 44)
        }

    }
}
