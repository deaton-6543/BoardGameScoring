/*
 See LICENSE folder for this sample’s licensing information.
 */

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
