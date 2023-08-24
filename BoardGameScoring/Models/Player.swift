//
//  Player.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/3/23.
//

import Foundation

struct Player: Codable, Identifiable {
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
