//
//  ContentView.swift
//  posusume
//
//  Created by Yudai.Hirose on 2021/03/28.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.655164046, longitude: 139.740663704), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Map(coordinateRegion: $region)
            ZStack {
                BarnBottomSheet()
                SpotListView()
                    .frame(alignment: .bottom)
                    .padding()
            }
            .frame(width: UIScreen.main.bounds.width, height: BarnBottomSheet.height, alignment: .bottom)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct Spot: Identifiable {
    @DocumentID var id: String?
    let latitude: Double
    let longitude: Double
    let name: String
    var imagePath: String?
}

struct SpotListCell: View {
    let spot: Spot
    var body: some View {
        Image(uiImage: .init())
            .frame(width: 90, height: 120)
            .background(Color.red)
    }
}
struct SpotListView: View {
    typealias Cell = SpotListCell
    var spots: [Spot] = [
        .init(id: "identifier1", latitude: 100, longitude: 100, name: "spot 1", imagePath: nil),
        .init(id: "identifier2", latitude: 100, longitude: 100, name: "spot 2", imagePath: nil),
        .init(id: "identifier3", latitude: 100, longitude: 100, name: "spot 3", imagePath: nil),
        .init(id: "identifier4", latitude: 100, longitude: 100, name: "spot 4", imagePath: nil),
        .init(id: "identifier5", latitude: 100, longitude: 100, name: "spot 5", imagePath: nil),
        .init(id: "identifier6", latitude: 100, longitude: 100, name: "spot 6", imagePath: nil),
        .init(id: "identifier7", latitude: 100, longitude: 100, name: "spot 7", imagePath: nil),
        .init(id: "identifier8", latitude: 100, longitude: 100, name: "spot 8", imagePath: nil),
        .init(id: "identifier9", latitude: 100, longitude: 100, name: "spot 9", imagePath: nil),
        .init(id: "identifier10", latitude: 100, longitude: 100, name: "spot 10", imagePath: nil),
        .init(id: "identifier11", latitude: 100, longitude: 100, name: "spot 11", imagePath: nil),
        .init(id: "identifier12", latitude: 100, longitude: 100, name: "spot 12", imagePath: nil),
        .init(id: "identifier13", latitude: 100, longitude: 100, name: "spot 13", imagePath: nil),
        .init(id: "identifier14", latitude: 100, longitude: 100, name: "spot 14", imagePath: nil),
        .init(id: "identifier15", latitude: 100, longitude: 100, name: "spot 15", imagePath: nil),
        .init(id: "identifier16", latitude: 100, longitude: 100, name: "spot 16", imagePath: nil),
        .init(id: "identifier17", latitude: 100, longitude: 100, name: "spot 17", imagePath: nil),
        .init(id: "identifier18", latitude: 100, longitude: 100, name: "spot 18", imagePath: nil),
        .init(id: "identifier19", latitude: 100, longitude: 100, name: "spot 19", imagePath: nil),
        .init(id: "identifier20", latitude: 100, longitude: 100, name: "spot 20", imagePath: nil),
        .init(id: "identifier21", latitude: 100, longitude: 100, name: "spot 21", imagePath: nil),
        .init(id: "identifier22", latitude: 100, longitude: 100, name: "spot 22", imagePath: nil),
        .init(id: "identifier23", latitude: 100, longitude: 100, name: "spot 23", imagePath: nil),
        .init(id: "identifier24", latitude: 100, longitude: 100, name: "spot 24", imagePath: nil),
        .init(id: "identifier25", latitude: 100, longitude: 100, name: "spot 25", imagePath: nil),
        .init(id: "identifier26", latitude: 100, longitude: 100, name: "spot 26", imagePath: nil),
        .init(id: "identifier27", latitude: 100, longitude: 100, name: "spot 27", imagePath: nil),
    ]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(spots) { spot in
                    Cell(spot: spot)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
