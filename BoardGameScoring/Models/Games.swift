//
//  Games.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/3/23.
//

import Foundation
import SwiftUI


struct Game: Hashable, Identifiable {
    
    let id: Int
    let name: String
    let symbol: String
    let color: Color
    let steps: [String]
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.name == rhs.name
    }
    
}

let cascadia = Game(id: 1, name: "Cascadia", symbol: "fish", color: .mint, steps: ["Bears", "Fish", "Foxes", "Hawks", "Elk"])
let wingspan = Game(id: 2, name: "Wingspan", symbol: "bird", color: .blue, steps: ["End of Match Bird Cards", "Bird Cards", "Eggs", "End of Round Bonus", "Goal Cards"])
