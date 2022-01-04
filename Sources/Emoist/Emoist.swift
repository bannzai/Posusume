//
//  Emoist.swift
//  SPAJAM2020Final
//
//  Created by 高松幸平 on 2020/11/08.
//

import Foundation
import Firebase
import SwiftUI

public class Emoist {
    struct Emoment {
        let name: String
        let word: String
    }

    struct Phrase {
        let subject: Emoment?
        let supporting: Emoment?

        func str() -> Result {
            return [
                Result(firstLine: "\(subject?.word ?? randSub())", secondLine: "それは\(randSub())"),
                Result(firstLine: "\(subject?.word ?? randSub())は", secondLine: "\(supporting?.word ?? randSup())もの"),
                Result(firstLine: "\(supporting?.word ?? randSup())", secondLine: "\(subject?.word ?? randSub())を見た"),
                Result(firstLine: "全部\(subject?.word ?? randSub())のせいだ", secondLine: nil),
                Result(firstLine: "いつか見たような\(subject?.word ?? randSub())", secondLine: nil),
                Result(firstLine: "今日もまた\(subject?.word ?? randSub())を", secondLine: "求め彷徨う"),
                Result(firstLine: "\(supporting?.word ?? randSup())の", secondLine: "\(subject?.word ?? randSub())の忘れがたさ"),
            ].randomElement()!
        }

        private func randSub() -> String {
            return [
                "淡い憧れ",
                "仄かな香り",
                "柔らかな光",
                "巡り合う二人",
                "望郷の念",
                "ひと時の幸福",
                "暖かな視線"
            ].randomElement()!
        }

        private func randSup() -> String {
            return [
                "あの日忘れた",
                "遠い日の",
                "いつか見たような",
                "憧憬の",
                "忘れざる",
                "別れがたい",
                "懐かしい"
            ].randomElement()!
        }
    }

    public struct Result {
        let firstLine: String
        let secondLine: String?
    }

    static let supportings: [Emoment] = [
        Emoment(name: "Plant",  word: "草生すような"),
        Emoment(name: "Grass",  word: "瑞々しい芝"),
        Emoment(name: "Tree",  word: "木々の陰間に"),
        Emoment(name: "Sky",  word: "天に見える"),
        Emoment(name: "Tourism",  word: "訪れを待つ"),
        Emoment(name: "Neighbourhood",  word: "友と暮らした"),
        Emoment(name: "Public Space",  word: "人々の集う"),
        Emoment(name: "Historic Site",  word: "古の"),
        Emoment(name: "Grass",  word: "緑に映える"),
        Emoment(name: "Apartment",  word: "暮らしのある"),
        Emoment(name: "Skyscraper",  word: "天高く"),
        Emoment(name: "Plaza",  word: "人々の集う"),
        Emoment(name: "Town Square",  word: "人々の集う"),
        Emoment(name: "Signage",  word: "何かを伝える"),
        Emoment(name: "Green",  word: "新緑の"),
        Emoment(name: "Suburb",  word: "閑静な"),
        Emoment(name: "Cloud",  word: "叢雲の"),
        Emoment(name: "Memorial",  word: "忘れざる"),
        Emoment(name: "Soil",  word: "砂地での"),
        Emoment(name: "Stairs",  word: "階段を超えて"),
        Emoment(name: "Darkness",  word: "暗闇の"),
        Emoment(name: "Classical Architecture",  word: "古くから伝わる"),
        Emoment(name: "Rock",  word: "堅固なる"),
        Emoment(name: "Ancient History",  word: "いにしへの"),
        Emoment(name: "Ruins",  word: "太古の"),
        Emoment(name: "Black",  word: "昏き"),
]
    static let subjects: [Emoment] = [
        Emoment(name: "Architecture",  word: "荘厳なる建屋"),
        Emoment(name: "Building",  word: "建造物"),
        Emoment(name: "City",  word: "街の息づき"),
        Emoment(name: "Flower",  word: "艶やかな花々"),
        Emoment(name: "Street",  word: "この街の暮らし"),
        Emoment(name: "House",  word: "安息の地"),
        Emoment(name: "Art",  word: "アート"),
        Emoment(name: "Town",  word: "この街の暮らし"),
        Emoment(name: "Human Settlement",  word: "人々の集い"),
        Emoment(name: "Statue",  word: "峻厳たる像"),
        Emoment(name: "Monument",  word: "モニュメント"),
        Emoment(name: "Road",  word: "この道"),
        Emoment(name: "Nature",  word: "大いなる自然"),
        Emoment(name: "Water",  word: "母なる水"),
        Emoment(name: "Landmark",  word: "象徴"),
        Emoment(name: "Sculpture",  word: "動かざる像"),
        Emoment(name: "Sidewalk",  word: "小道"),
        Emoment(name: "Home",  word: "帰るべき場所"),
        Emoment(name: "Pedestrian",  word: "道の先"),
        Emoment(name: "Door",  word: "開くべき場所"),
        Emoment(name: "Tower",  word: "天を衝く塔"),
        Emoment(name: "Temple",  word: "教えの場"),
        Emoment(name: "Place Of Worship",  word: "祈りの場"),
        Emoment(name: "Vacation",  word: "安息のとき"),
        Emoment(name: "Walkway",  word: "小道"),
        Emoment(name: "Wall",  word: "そびえる壁"),
        Emoment(name: "Alley",  word: "小道"),
        Emoment(name: "Shrine",  word: "祈りの場"),
        Emoment(name: "Asphalt",  word: "舗道"),
        Emoment(name: "Skyline",  word: "地平線"),
        Emoment(name: "Graffiti",  word: "誰かにとっての絵画"),
        Emoment(name: "Car",  word: "車両"),
        Emoment(name: "Marketplace",  word: "商いの場"),
        Emoment(name: "Cityscape",  word: "街の景色"),
        Emoment(name: "Travel",  word: "旅路"),
        Emoment(name: "Lake",  word: "遥かな湖畔")
    ]

    func emiful(labels: [CloudVision.Label]) -> Result {
        let sub = labels.compactMap { label -> Emoment? in
            Emoist.subjects.filter {
                label.description == $0.name
            }.first
        }.first

        let sup = labels.compactMap { label -> Emoment? in
            Emoist.supportings.filter {
                label.description == $0.name
            }.first
        }.first
        
        return Phrase(subject: sub, supporting: sup).str()
    }
}

struct EmoistEnvironmentKey: EnvironmentKey {
    static var defaultValue: Emoist = .init()
}

extension EnvironmentValues {
    var emoist: Emoist {
        get {
            self[EmoistEnvironmentKey.self]
        }
        set {
            self[EmoistEnvironmentKey.self] = newValue
        }
    }
}

