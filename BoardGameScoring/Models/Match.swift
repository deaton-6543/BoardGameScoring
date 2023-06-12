//
//  Match.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/3/23.
//

import Foundation

struct Match: Identifiable, Codable {
    let id: UUID
    var date: Date
    var game: String
    var scores: [Player: Int]
    
    init(id: UUID = UUID(), date: Date, game: String, scores: [Player : Int]) {
        self.id = id
        self.date = date
        self.game = game
        self.scores = scores
    }
}

extension Match {
    
    
    static let sampleData: [Match] = [
        Match(date: Date(), game: cascadia.name, scores: [Player.samplePlayers[0]: 5, Player.samplePlayers[1]: 10]),
        Match(date: Date(timeIntervalSinceNow: 60 * 60), game: wingspan.name, scores: [Player.samplePlayers[1]: 12, Player.samplePlayers[2]: 11]),
        Match(date: Date(timeIntervalSinceNow: 60 * 60 * 48), game: cascadia.name, scores: [Player.samplePlayers[0]: 8, Player.samplePlayers[2]: 15])
    ]
}
