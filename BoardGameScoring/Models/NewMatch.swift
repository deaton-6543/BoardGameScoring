//
//  NewMatch.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 8/10/23.
//

import Foundation


class NewMatch: Identifiable, Codable {
    
     static var shared = NewMatch()
    
    var id: String
    var date: Date
    var game: Game {
        didSet {
            self.players = getInitialPlayerList()
        }
    }
    var scores: [Score] = []
    var stepScores: [StepScore] = []
    var bonusScores: [BonusScore] = []
    var players: [Player] = []
    var startingNewMatch = true
    var scoreStepsComplete: Bool {
        stepScores.count == stepScores.filter({ $0.isComplete }).count
    }
    
    init(id: String = UUID().uuidString, date: Date = Date(), game: Game = .cascadia, scores: [Score] = [], players: [Player] = [], stepScores: [StepScore] = [], bonusScores: [BonusScore] = []) {
        self.id = id
        self.date = date
        self.game = game
        self.players = players
        self.scores = scores
        self.stepScores = stepScores
        self.bonusScores = bonusScores
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case game
        case scores
        case stepScores
        case bonusScores
        case players
        case startingNewMatch
        case scoreStepsComplete
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        date = try values.decode(Date.self, forKey: .date)
        game = try values.decode(Game.self, forKey: .game)
        scores = try values.decode([Score].self, forKey: .scores)
        stepScores = try values.decode([StepScore].self, forKey: .stepScores)
        bonusScores = try values.decode([BonusScore].self, forKey: .bonusScores)
        players = try values.decode([Player].self, forKey: .players)
        startingNewMatch = try values.decode(Bool.self, forKey: .startingNewMatch)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(game, forKey: .game)
        try container.encode(scores, forKey: .scores)
        try container.encode(stepScores, forKey: .stepScores)
        try container.encode(bonusScores, forKey: .bonusScores)
        try container.encode(players, forKey: .players)
        try container.encode(startingNewMatch, forKey: .startingNewMatch)
        try container.encode(scoreStepsComplete, forKey: .scoreStepsComplete)
    }
    
    func getInitialPlayerList() -> [Player] {
        
        var players: [Player] = []
        let matchHistory: [HistoricalMatch] = DataModel.shared.historicalMatches
        
        if startingNewMatch {
            let matches = matchHistory.filter({ match in
                match.game == game.name
            }).sorted { $0.date > $1.date }
            
            if let lastMatch = matches.first {
                for score in lastMatch.scores {
                    players.append(score.player)
                }
            }
        } else {
            players = self.players
        }
        return players
    }
    
    func resetNewMatch() {
        self.id = UUID().uuidString
        self.date = Date()
        self.game = .cascadia
        self.players = []
        self.scores = []
        self.stepScores = []
        self.bonusScores = []
        self.startingNewMatch = true
    }
    
}

extension NewMatch: Equatable, Hashable {
    static func == (lhs: NewMatch, rhs: NewMatch) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension NewMatch {
    static let sampleStepText = "Some text that explains how to scrore this step."
    
    static var sampleNewMatch = NewMatch(game: .cascadia, scores: [Score(player: Player(name: "Lisa"), score: 5), Score(player: Player(name: "Dennis"), score: 6)], players: [Player(name: "Lisa"), Player(name: "Dennis")], stepScores: [
        StepScore(step: "Bears", stepText: sampleStepText, scores: [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Dennis"), score: 4)], isComplete: true),
        StepScore(step: "Salmon", stepText: sampleStepText, scores: [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Dennis"), score: 4)], isComplete: false),
        StepScore(step: "Foxes", stepText: sampleStepText, scores: [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Dennis"), score: 4)], isComplete: true),
        StepScore(step: "Hawks", stepText: sampleStepText, scores: [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Dennis"), score: 4)], isComplete: false),
        StepScore(step: "Elk", stepText: sampleStepText, scores: [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Dennis"), score: 4)], isComplete: true)
        ]
        )

}
