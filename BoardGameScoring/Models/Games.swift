//
//  Games.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/3/23.
//

import Foundation
import SwiftUI


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
