//
//  Spot.swift
//  Posusume
//
//  Created by Yudai.Hirose on 2021/04/07.
//

import Foundation
import FirebaseFirestoreSwift

struct Spot: Identifiable {
    @DocumentID var id: String?
    let latitude: Double
    let longitude: Double
    let name: String
    var imagePath: String?
}
