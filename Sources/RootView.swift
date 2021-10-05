import SwiftUI
import MapKit
import Combine

struct RootView: View {
    @Environment(\.locationManager) var locationManager

    @StateObject private var viewModel = RootViewModel()

    @State var error: IdentifiableError?

    var body: some View {
        Group {
            switch viewModel.viewKind {
            case .waiting:
                Map(coordinateRegion: .init(get: { defaultRegion }, set: { _ in }))
                    .edgesIgnoringSafeArea(.all)
            case .requireLocationPermission:
                RequireLocationAuthorizationView()
            case let .main(me):
                SpotMapView()
                    .environment(\.me, me)
            }
        }
        .task {
            do {
                try await viewModel.process()
            } catch {
                self.error = .init(error)
            }
        }
        .alert(item: $error) { identifiableError in
            Alert(
                title: Text("予期せぬエラーが発生しました"),
                message: Text("通信環境をお確かめください"),
                dismissButton: .default(Text("再読み込み"), action: {
                    Task {
                        do {
                            try await viewModel.process()
                        } catch {
                            self.error = .init(error)
                        }
                    }
                })
            )
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
