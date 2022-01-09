import Foundation
import SwiftUI

struct SpotMapAccountIconView: View {
    @Environment(\.me) var me

    var body: some View {
        if me.isAnonymous {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
        } else {

        }
    }
}
