//
//  Match.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/3/23.
//

import Foundation
import SwiftUI

class NewMatch: Identifiable, ObservableObject {
    
    static var shared = NewMatch()
    
    let id: UUID
    var date: Date
    @Published var game: Game {
        didSet {
            self.players = getInitialPlayerList()
        }
    }
    @Published var scores: [Score] = []
    @Published var stepScores: [StepScore] = []
    @Published var players: [Player] = []
    
    let matchHistory: [HistoricalMatch] = HistoricalMatch.sampleData    // need to update to initialize from the data store once the storage approach
    // in the data model
    
//        let sampleData = NewMatch(id: UUID(), date: Date(), game: .cascadia, scores: [Score(player: Player(name: "Lisa"), score: 5), Score(player: Player(name: "Dennis"), score: 6)], players: [Player(name: "Lisa"), Player(name: "Dennis")], stepScores: [
//            StepScore(step: "Bears", scores: [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Dennis"), score: 4)], isComplete: true),
//            StepScore(step: "Salmon", scores: [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Dennis"), score: 4)], isComplete: false),
//            StepScore(step: "Foxes", scores: [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Dennis"), score: 4)], isComplete: true),
//            StepScore(step: "Hawks", scores: [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Dennis"), score: 4)], isComplete: false),
//            StepScore(step: "Elk", scores: [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Dennis"), score: 4)], isComplete: true)
//            ]
//            )
    
    //    var sampleData: NewMatch = NewMatch(game: .cascadia,scores: [Score(player: Player.samplePlayers[1], score: 12), Score(player: Player.samplePlayers[2], score: 11)], players: [Player(name: "Lisa"), Player(name: "Dennis")], stepScores: StepScore.sampleStepScores)
    
    init(id: UUID = UUID(), date: Date = Date(), game: Game = .cascadia, scores: [Score] = [], players: [Player] = [], stepScores: [StepScore] = []) {
        self.id = id
        self.date = date
        self.game = game
        self.players = players
        self.scores = scores
        self.stepScores = stepScores
    }
    
    func initializeNewMatch() {
        
        
        // Initialize the scores array with the list of players
        for player in players {
            scores.append(Score(player: player, score: 0))
        }
        
        // Initialize the stepScores for each step in the game
        for step in game.steps {
            stepScores.append(StepScore(step: step, scores: scores, isComplete: false))
        }
    }
    
    func getInitialPlayerList() -> [Player] {
        
        var players: [Player] = []
        //        newMatch.game = game  // Update the new match to reflect the game passed from the parent view binding
        let matches = matchHistory.filter({ match in
            match.game == game.name
        }).sorted { $0.date > $1.date }
        
        guard let lastMatch = matches.first else {return []}
        for score in lastMatch.scores {
            //            newMatch.scores.append(score)
            players.append(score.player)
        }
        return players
    }
    
    func getLeaderBoard(players: [Player]) -> [PlayerRecord]? {
        var leaderBoard: [PlayerRecord] = []
        
        guard !players.isEmpty else { return nil }
        for player in players {
            leaderBoard.append(PlayerRecord(game: game, player: player, matches: HistoricalMatch.sampleData))
        }
        leaderBoard.sort { $0.wins > $1.wins }
        
        return leaderBoard
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


struct Player: Codable, Identifiable {
//    let id: UUID
    var name: String
    var id: String {
        self.name
    }
    
//    init(id: UUID(), name: String) {
//        self.id = id
//        self.name = name
//    }
}

extension Player: Hashable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Player {
    static let samplePlayers: [Player] = [Player(name: "Lisa"), Player(name: "Dennis"), Player(name: "John")]
    static let emptyPlayer: Player = Player(name: "Empty")
}


enum Game: Int, Hashable, Identifiable, Codable, CaseIterable {
    
    case cascadia, wingspan
    
    var id: Int { rawValue }
    var name: String {
        switch self {
        case .cascadia: return "Cascadia"
        case .wingspan: return "Wingspan"
        }
    }
    
    var symbol: String {
        switch self {
        case .cascadia: return "fish"
        case .wingspan: return "bird"
        }
    }
    
    var theme: Theme {
        switch self {
        case .cascadia: return .flora
        case .wingspan: return .orange
        }
    }
    
    var steps: [String] {
        switch self {
        case .cascadia:
            return ["Bears", "Salmon", "Foxes", "Hawks", "Elk", "Mountains",".MountainsBonus", "Water", ".WaterBonus", "Prarie", ".PrarieBonus", "Desert", ".DesertBonus", "Forest", ".ForestBonus", "Pine Cones"]
        case .wingspan:
            return ["End of Match Bird Cards", "Bird Cards", "Eggs", "End of Round Bonus", "Goal Cards"]
        }
    }
}

struct PlayerRecord: Identifiable {
    let game: Game
    let player: Player
    let matches: [HistoricalMatch]
    
    var id: String {
        player.id
    }
    
    var wins: Int {
        
        //need to make some of these properties optional and include logic to handle
        var gameMatches: [HistoricalMatch] = []
        var wins: Int = 0
        var matchScores: [[Score]] = [[]] // collection of matches (collection of player scores)
        var sortedMatchScore: [Score] = []
        
        gameMatches = matches.filter{ $0.game == game.name }
        
        // extract the scores from the matches
        matchScores = gameMatches.map { $0.scores }
        
        
        // sort each matchScores in descending order and increment when
        // this player's score is first (a win)
        for matchScore in matchScores {
            sortedMatchScore = matchScore.sorted { $0.score > $1.score }
                        
            if let index = sortedMatchScore.firstIndex(where: { $0.player == player }) {
                if index == 0 { wins += 1 }
            }
        }
        
        return wins
        
    }
    
    var losses: Int {
        return HistoricalMatch.sampleData.filter { $0.game == game.name }.count - self.wins
    }
    
}

enum Theme: String, CaseIterable, Identifiable, Codable {

    case banana
    case blue
    case bubblegum
    case flora
    case indigo
    case orange
    
    var accentColor: Color {
        switch self {
        case .bubblegum, .banana, .flora, .orange: return .black
        case .indigo, .blue: return .white
        }
    }
    var mainColor: Color {
        Color(rawValue)
    }
    var name: String {
        rawValue
    }
    var id: String {
        name
    }
}

struct Score: Codable, Identifiable {
    let player: Player
    var score: Int
    var id: Player {
        player
    }
    
    init(player: Player, score: Int) {
        self.player = player
        self.score = score
    }
}

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

struct HistoricalMatch: Identifiable, Codable {
    let id: UUID
    var date: Date
    var game: String
    var scores: [Score]
    
    init(id: UUID = UUID(), date: Date, game: String, scores: [Score]) {
        self.id = id
        self.date = date
        self.game = game
        self.scores = scores
    }
}

extension HistoricalMatch: Equatable, Hashable {
    static func == (lhs: HistoricalMatch, rhs: HistoricalMatch) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

extension HistoricalMatch {
    
    static let sampleData: [HistoricalMatch] = [
        HistoricalMatch(date: Date(), game: Game.cascadia.name,
                        scores: [Score(player: Player.samplePlayers[0], score: 5), Score(player: Player.samplePlayers[1], score: 10)]),
        HistoricalMatch(date: Date(timeIntervalSinceNow: 60 * 60), game: Game.wingspan.name ,
                        scores: [Score(player: Player.samplePlayers[1], score: 12), Score(player: Player.samplePlayers[2], score: 11)]),
        HistoricalMatch(date: Date(timeIntervalSinceNow: 60 * 60 * 48), game: Game.cascadia.name,
                        scores: [Score(player: Player.samplePlayers[0], score: 8), Score(player: Player.samplePlayers[2], score: 15)])
    ]
    
}

let aNewMatch = NewMatch()

var varNewMatch = NewMatch()

varNewMatch.game = .wingspan


    
    

