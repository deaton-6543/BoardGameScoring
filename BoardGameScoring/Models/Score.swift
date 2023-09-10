//
//  Score.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/20/23.
//

import Foundation

struct Score: Codable, Identifiable {
    let player: Player
    var score: Int?
    var id: Player {
        player
    }
    
    init(player: Player, score: Int?) {
        self.player = player
        self.score = score
    }
}
