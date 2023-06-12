//
//  Player.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/3/23.
//

import Foundation

struct Player: Codable, Identifiable {
    let id: UUID
    var name: String
    var wins: Int {
        // Return the number of matches where the player had the highest score
        return 0
    }
    var losses: Int {
        // Return the number of matches where the player did not have the highest score.
        return 0
    }
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

extension Player: Hashable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Player {
    static let samplePlayers: [Player] = [Player(name: "Lisa"), Player(name: "Dennis"), Player(name: "John")]
}
