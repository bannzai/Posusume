//
//  Emoist.swift
//  SPAJAM2020Final
//
//  Created by 高松幸平 on 2020/11/08.
//

import Foundation
import Firebase

class Emoist {
    struct Emoment {
        enum Role {
            case subject
            case supporting
        }
        struct Word {
            let phrase: String
        }

        let name: String
        let role: Role
        let word: String
    }

    struct Phrase {
        let sub: Emoment?
        let sup: Emoment?

        func str() -> Result {
            return [
                Result(firstLine: "\(sub?.word ?? randSub())", secondLine: "それは\(randSub())"),
                Result(firstLine: "\(sub?.word ?? randSub())は", secondLine: "\(sup?.word ?? randSup())もの"),
                Result(firstLine: "\(sup?.word ?? randSup())", secondLine: "\(sub?.word ?? randSub())を見た"),
                Result(firstLine: "全部\(sub?.word ?? randSub())のせいだ", secondLine: nil),
                Result(firstLine: "いつか見たような\(sub?.word ?? randSub())", secondLine: nil),
                Result(firstLine: "今日もまた\(sub?.word ?? randSub())を", secondLine: "求め彷徨う"),
                Result(firstLine: "\(sup?.word ?? randSup())の", secondLine: "\(sub?.word ?? randSub())の忘れがたさ"),
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

    struct Result {
        let firstLine: String
        let secondLine: String?
    }

    static let emoments: [Emoment] = [
        Emoment(name: "Architecture", role: .subject, word: "荘厳なる建屋"),
        Emoment(name: "Building", role: .subject, word: "建造物"),
        Emoment(name: "City", role: .subject, word: "街の息づき"),
        Emoment(name: "Flower", role: .subject, word: "艶やかな花々"),
        Emoment(name: "Plant", role: .supporting, word: "草生すような"),
        Emoment(name: "Grass", role: .supporting, word: "瑞々しい芝"),
        Emoment(name: "Tree", role: .supporting, word: "木々の陰間に"),
        Emoment(name: "Street", role: .subject, word: "この街の暮らし"),
        Emoment(name: "House", role: .subject, word: "安息の地"),
        Emoment(name: "Art", role: .subject, word: "アート"),
        Emoment(name: "Neighbourhood", role: .supporting, word: "友と暮らした"),
        Emoment(name: "Town", role: .subject, word: "この街の暮らし"),
        Emoment(name: "Human Settlement", role: .subject, word: "人々の集い"),
        Emoment(name: "Sky", role: .supporting, word: "天に見える"),
        Emoment(name: "Tourism", role: .supporting, word: "訪れを待つ"),
        Emoment(name: "Statue", role: .subject, word: "峻厳たる像"),
        Emoment(name: "Monument", role: .subject, word: "モニュメント"),
        Emoment(name: "Road", role: .subject, word: "この道"),
        Emoment(name: "Nature", role: .subject, word: "大いなる自然"),
        Emoment(name: "Water", role: .subject, word: "母なる水"),
        Emoment(name: "Landmark", role: .subject, word: "象徴"),
        Emoment(name: "Sculpture", role: .subject, word: "動かざる像"),
        Emoment(name: "Sidewalk", role: .subject, word: "小道"),
        Emoment(name: "Home", role: .subject, word: "帰るべき場所"),
        Emoment(name: "Public Space", role: .supporting, word: "人々の集う"),
        Emoment(name: "Historic Site", role: .supporting, word: "古の"),
        Emoment(name: "Grass", role: .supporting, word: "緑に映える"),
        Emoment(name: "Apartment", role: .supporting, word: "暮らしのある"),
        Emoment(name: "Pedestrian", role: .subject, word: "道の先"),
        Emoment(name: "Door", role: .subject, word: "開くべき場所"),
        Emoment(name: "Tower", role: .subject, word: "天を衝く塔"),
        Emoment(name: "Skyscraper", role: .supporting, word: "天高く"),
        Emoment(name: "Plaza", role: .supporting, word: "人々の集う"),
        Emoment(name: "Town Square", role: .supporting, word: "人々の集う"),
        Emoment(name: "Temple", role: .subject, word: "教えの場"),
        Emoment(name: "Place Of Worship", role: .subject, word: "祈りの場"),
        Emoment(name: "Vacation", role: .subject, word: "安息のとき"),
        Emoment(name: "Signage", role: .supporting, word: "何かを伝える"),
        Emoment(name: "Walkway", role: .subject, word: "小道"),
        Emoment(name: "Green", role: .supporting, word: "新緑の"),
        Emoment(name: "Suburb", role: .supporting, word: "閑静な"),
        Emoment(name: "Wall", role: .subject, word: "そびえる壁"),
        Emoment(name: "Alley", role: .subject, word: "小道"),
        Emoment(name: "Shrine", role: .subject, word: "祈りの場"),
        Emoment(name: "Cloud", role: .supporting, word: "叢雲の"),
        Emoment(name: "Memorial", role: .supporting, word: "忘れざる"),
        Emoment(name: "Soil", role: .supporting, word: "砂地での"),
        Emoment(name: "Asphalt", role: .subject, word: "舗道"),
        Emoment(name: "Stairs", role: .supporting, word: "階段を超えて"),
        Emoment(name: "Skyline", role: .subject, word: "地平線"),
        Emoment(name: "Graffiti", role: .subject, word: "誰かにとっての絵画"),
        Emoment(name: "Darkness", role: .supporting, word: "暗闇の"),
        Emoment(name: "Car", role: .subject, word: "車両"),
        Emoment(name: "Classical Architecture", role: .supporting, word: "古くから伝わる"),
        Emoment(name: "Black", role: .supporting, word: "昏き"),
        Emoment(name: "Marketplace", role: .subject, word: "商いの場"),
        Emoment(name: "Cityscape", role: .subject, word: "街の景色"),
        Emoment(name: "Travel", role: .subject, word: "旅路"),
        Emoment(name: "Lake", role: .subject, word: "遥かな湖畔"),
        Emoment(name: "Rock", role: .supporting, word: "堅固なる"),
        Emoment(name: "Ancient History", role: .supporting, word: "いにしへの"),
        Emoment(name: "Ruins", role: .supporting, word: "太古の"),
    ]

    struct VisionImageLabel {
        let text: String
    }

    func emiful(labels: [VisionImageLabel]) -> Result {
        let sub = labels.compactMap { label -> Emoment? in
            Emoist.emoments.filter {$0.role == .subject}.filter {
                label.text == $0.name
            }.first
        }.first

        let sup = labels.compactMap { label -> Emoment? in
            Emoist.emoments.filter {$0.role == .supporting}.filter {
                label.text == $0.name
            }.first
        }.first
        return Phrase(sub: sub, sup: sup).str()
    }
}
