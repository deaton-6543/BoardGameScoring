//
//  BonusScore.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 9/5/23.
//

import Foundation

struct BonusScore: Identifiable, Codable {
    let bonus: String
//    var stepScore: StepScore? = nil
    var bonusScores: [Score]  = []
    var bonusScoreString: String = ""
    var id: String {
        bonus
    }
}

extension BonusScore: Equatable {
    static func ==(lhs:BonusScore, rhs: BonusScore) -> Bool {
        lhs.id == rhs.id
    }
}

extension BonusScore {
    static let scores: [Score] = [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Tom"), score: 4)]
    static let emptyScores: [Score] = []
    static let sampleBonusScores = [
        BonusScore(bonus: "Water"),
        BonusScore(bonus: "Mountains"),
        BonusScore(bonus: "Prarie"),
        BonusScore(bonus: "Desert"),
        BonusScore(bonus: "Forest")
        ]
}
