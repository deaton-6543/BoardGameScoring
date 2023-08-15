//
//  HistoricalMatch.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/28/23.
//

import Foundation

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

