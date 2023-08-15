import UIKit
import Foundation
import SwiftUI
import PlaygroundSupport

struct Player: Codable, Identifiable {
//    let id: UUID
    var name: String
    var id: String {
        self.name
    }
    
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

struct PlayerRecord: Identifiable, Codable {
    let game: Game
    let player: Player
    let matches: [HistoricalMatch]
    
    var id: String {
        player.id
    }
    
   
    var playerMatchCount: Int {
        
        var gameMatches: [HistoricalMatch] = []
        var matchScores: [[Score]] = [[]] // collection of matches (collection of player scores)
        var count: Int = 0
        
        // extract the matches for this game from the saved historical matches
        gameMatches = matches.filter{ $0.game == game.name }
        
        // extract the scores from the matches
        matchScores = gameMatches.map { $0.scores }

        // Count the number of matches the player has played for this game
        for matchScore in matchScores {
             if (matchScore.contains { score in
                score.player == player
             }) {
                 count += 1
             }
        }
        return count
    }
    
    var wins: Int {
        
        //need to make some of these properties optional and include logic to handle
        var gameMatches: [HistoricalMatch] = []
        var wins: Int = 0
        var matchScores: [[Score]] = [[]] // collection of matches (collection of player scores)
        var sortedMatchScore: [Score] = []
//        var playerDoesExist: Bool = false
//        var playerMatchCount: Int = 0
        
        gameMatches = matches.filter{ $0.game == game.name }
        
        // extract the scores from the matches
        matchScores = gameMatches.map { $0.scores }
        
       
        if self.playerMatchCount != 0 {
            // sort each matchScores in descending order and increment when
            // this player's score is first (a win)
            for matchScore in matchScores {
                sortedMatchScore = matchScore.sorted { $0.score > $1.score }
                            
                if let index = sortedMatchScore.firstIndex(where: { $0.player == player }) {
                    if index == 0 { wins += 1 }
                }
            }

        } else {
            wins = 0
        }
        
        return wins
        
    }
    
    var losses: Int {
       
        if playerMatchCount != 0 {
            return playerMatchCount - self.wins
        } else {
            return 0
        }
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


class DataModel: ObservableObject, Codable {
    static let shared = DataModel()
    
//    @Published var historicalMatches: [HistoricalMatch] = []       // HistoricalMatch.sampleData
    var historicalMatches: [HistoricalMatch] = []
//    @Published var newMatch: NewMatch?
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("historicalMatchScores.data")
    }
    
    func load() async throws {
        let task = Task<[HistoricalMatch], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let historicalMatches = try JSONDecoder().decode([HistoricalMatch].self, from: data)
            return historicalMatches
        }
        let historicalMatches = try await task.value
        self.historicalMatches = historicalMatches
    }
    
    func save(completedMatch: HistoricalMatch) async throws {
        historicalMatches.append(completedMatch)
        let task = Task {
            let data = try JSONEncoder().encode(historicalMatches)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }

}


//@MainActor class NewMatch: Identifiable, ObservableObject, Codable {
    
class NewMatch: Identifiable, ObservableObject, Codable {
    
    static var shared = NewMatch()
    
    let id: String
//    var date: Date
    @Published var game: Game
//    @Published var game: Game {
//        didSet {
//            self.players = getInitialPlayerList()
//        }
//    }
//    @Published var scores: [Score] = []
//    @Published var stepScores: [StepScore] = []
//    @Published var players: [Player] = []
//    @Published var isPresentingScoringView = false
    @Published var startingNewMatch = true
//    @Published var stepScoreIndex: Int = 0
//    @Published var isPresentingScoringStep: Bool = false
//    var scoreStepsComplete: Bool {
//        stepScores.count == stepScores.filter({ $0.isComplete }).count
//    }
    
    //    @MainActor init(id: UUID = UUID(), date: Date = Date(), game: Game = .cascadia, scores: [Score] = [], players: [Player] = [], stepScores: [StepScore] = []) {
    init(id: String = UUID().uuidString, game: Game = .cascadia) {
//    init(id: String = UUID().uuidString, date: Date = Date(), game: Game = .cascadia, scores: [Score] = [], players: [Player] = [], stepScores: [StepScore] = []) {
        self.id = id
//        self.date = date
        self.game = game
//        self.players = players
//        self.scores = scores
//        self.stepScores = stepScores
    }
    
    enum CodingKeys: String, CodingKey {
        case id
//        case date
        case game
//        case scores
//        case stepScores
//        case players
//        case isPresentingScoringView
        case startingNewMatch
//        case stepScoreIndex
//        case isPresentingScoringStep
//        case scoreStepsComplete
    }
    
//    @MainActor required init(from decoder: Decoder) async throws {
    @MainActor required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
//        date = try values.decode(Date.self, forKey: .date)
        game = try values.decode(Game.self, forKey: .game)
//        scores = try values.decode([Score].self, forKey: .scores)
//        stepScores = try values.decode([StepScore].self, forKey: .stepScores)
//        players = try values.decode([Player].self, forKey: .players)
//        isPresentingScoringView = try values.decode(Bool.self, forKey: .isPresentingScoringView)
        startingNewMatch = try values.decode(Bool.self, forKey: .startingNewMatch)
//        stepScoreIndex = try values.decode(Int.self, forKey: .stepScoreIndex)
//        isPresentingScoringStep = try values.decode(Bool.self, forKey: .isPresentingScoringStep)
    }
    
//    @MainActor func encode(to encoder: Encoder) async throws {
    @MainActor func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
//        try container.encode(date, forKey: .date)
        try container.encode(game, forKey: .game)
//        try container.encode(scores, forKey: .scores)
//        try container.encode(stepScores, forKey: .stepScores)
//        try container.encode(players, forKey: .players)
//        try container.encode(isPresentingScoringView, forKey: .isPresentingScoringView)
        try container.encode(startingNewMatch, forKey: .startingNewMatch)
//        try container.encode(stepScoreIndex, forKey: .stepScoreIndex)
//        try container.encode(isPresentingScoringStep, forKey: .isPresentingScoringStep)
//        try container.encode(scoreStepsComplete, forKey: .scoreStepsComplete)
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
        }
        return players
    }

}

