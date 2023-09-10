//
//  NavigationModel.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/26/23.
//

import Foundation
import SwiftUI

final class NavigationModel: ObservableObject {
    @Published var selectedTab: ContentViewTab = .games     // The selected tab from the home screen
    @Published var gamePath: [GameDestination] = []         // Navigation path for the game score screens
    @Published var playersPath: [PlayerDestination] = []    // Navigation path for the player screens
    @Published var path: NavigationPath
    
    private let savePath = URL.documentsDirectory.appending(path: "NavigationPathStore")

    init() {
        if let data = try? Data(contentsOf: savePath) {
            do {
                let decoded = try JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data)
                self.path = NavigationPath(decoded)
            } catch {
                self.path = NavigationPath()
            }
        } else {
            self.path = NavigationPath()
        }
    }
    
    func save() {
        guard let codedPath = path.codable else { return }
        
        do {
            let data = try JSONEncoder().encode(codedPath)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation stack data")
        }
    }
    
    func reset() {
        self.path = NavigationPath()
        save()
    }
}

enum ContentViewTab: String, Codable {
    case games
    case players
}

enum GameDestination: String, Codable {
    case newMatch       // View for setting up a new match
    case matchScore     // View for stepping through the scoring of a match
    case stepScore      // View for recording player scores for a step in the scoring array
    case matchHistory   // View for displaying the history of matches between the players in the current game
}

enum PlayerDestination: String, Codable {
    case players        // View for seeing existing players and setting up new players
    case playerDetail   // View for seeing a player's historical record
}
