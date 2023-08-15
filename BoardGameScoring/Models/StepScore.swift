//
//  StepScore.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/22/23.
//

import Foundation

struct StepScore: Identifiable, Codable {
    let step: String
    var scores: [Score]
    var isComplete: Bool
    // let scoringText = "Add text to each step that will appear on the scoring screen to tell the user
    // how to calculate the score entry."
    var id: String {
        step
    }
}

extension StepScore: Equatable {
    static func ==(lhs:StepScore, rhs: StepScore) -> Bool {
        lhs.id == rhs.id
    }
}

extension StepScore {
    static let scores: [Score] = [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Tom"), score: 4)]
    static let emptyScores: [Score] = []
    static let sampleStepScores = [
        StepScore(step: "Bears", scores: scores, isComplete: true),
        StepScore(step: "Salmon", scores: scores, isComplete: false),
        StepScore(step: "Foxes", scores: scores, isComplete: true),
        StepScore(step: "Hawks", scores: scores, isComplete: false),
        StepScore(step: "Elk", scores: scores, isComplete: true),
        StepScore(step: "Mountains", scores: scores, isComplete: false),
        StepScore(step: ".MountainsBonus", scores: scores, isComplete: true),
        StepScore(step: "Water", scores: scores, isComplete: true),
        StepScore(step: ".WaterBonus", scores: scores, isComplete: false),
        StepScore(step: "Prarie", scores: scores, isComplete: true),
        StepScore(step: ".PrarieBonus", scores: scores, isComplete: false),
        StepScore(step: "Desert", scores: scores, isComplete: true),
        StepScore(step: ".DesertBonus", scores: scores, isComplete: false),
        StepScore(step: "Forest", scores: scores, isComplete: true),
        StepScore(step: ".ForestBonus", scores: scores, isComplete: false),
        StepScore(step: "Pine Cones", scores: scores, isComplete: true)
        ]
    static let emptyStepScore = StepScore(step: "", scores: emptyScores, isComplete: false)
}
