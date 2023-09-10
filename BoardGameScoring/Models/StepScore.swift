//
//  StepScore.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/22/23.
//

import Foundation

struct StepScore: Identifiable, Codable {
    let step: String
    let stepText: String
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
    static let sampleStepText = "Some text that explains how to scrore this step."
    static let sampleStepScores = [
        StepScore(step: "Bears", stepText: sampleStepText, scores: scores, isComplete: true),
        StepScore(step: "Salmon", stepText: sampleStepText, scores: scores, isComplete: false),
        StepScore(step: "Foxes", stepText: sampleStepText, scores: scores, isComplete: true),
        StepScore(step: "Hawks", stepText: sampleStepText, scores: scores, isComplete: false),
        StepScore(step: "Elk", stepText: sampleStepText, scores: scores, isComplete: true),
        StepScore(step: "Mountains", stepText: sampleStepText, scores: scores, isComplete: false),
        StepScore(step: "Water", stepText: sampleStepText, scores: scores, isComplete: true),
        StepScore(step: "Prarie", stepText: sampleStepText, scores: scores, isComplete: true),
        StepScore(step: "Desert", stepText: sampleStepText, scores: scores, isComplete: true),
        StepScore(step: "Forest", stepText: sampleStepText, scores: scores, isComplete: true),
        StepScore(step: "Pine Cones", stepText: sampleStepText, scores: scores, isComplete: true)
        ]
    static let emptyStepScore = StepScore(step: "", stepText: sampleStepText, scores: emptyScores, isComplete: false)
}
