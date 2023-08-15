import UIKit
import Foundation

enum Game: Int, Hashable, Identifiable, Codable {
    
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

import SwiftUI

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
