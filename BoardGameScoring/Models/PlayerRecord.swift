//
//  PlayerRecord.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/13/23.
//

import Foundation

//Move this to HistoricalMatches getPlayerRecord(for:) method -> wins and losses for the player

struct PlayerRecord: Identifiable, Codable {
    let game: Game
    let player: Player
    let matches: [HistoricalMatch]
    
    var id: String {
        player.id
    }
        
    var playerMatchCount: Int {
        
        var gameMatches: [HistoricalMatch] = []
        var matchScores: [[Score]] = [[]] // collection of matches (collection of player scores)
        var count: Int = 0
        
        // extract the matches for this game from the saved historical matches
        gameMatches = matches.filter{ $0.game == game.name }
        
        // extract the scores from the matches
        matchScores = gameMatches.map { $0.scores }

        // Count the number of matches the player has played for this game
        for matchScore in matchScores {
             if (matchScore.contains { score in
                score.player == player
             }) {
                 count += 1
             }
        }
        return count
    }
    
    var wins: Int {
        
        //need to make some of these properties optional and include logic to handle
        var gameMatches: [HistoricalMatch] = []
        var wins: Int = 0
        var matchScores: [[Score]] = [[]] // collection of matches (collection of player scores)
        var sortedMatchScore: [Score] = []
        
        gameMatches = matches.filter{ $0.game == game.name }
        
        // extract the scores from the matches
        matchScores = gameMatches.map { $0.scores }
                
        if self.playerMatchCount != 0 {
            // sort each matchScores in descending order and increment when
            // this player's score is first (a win)
            for matchScore in matchScores {
                sortedMatchScore = matchScore.sorted { $0.score! > $1.score! }
                            
                if let index = sortedMatchScore.firstIndex(where: { $0.player == player }) {
                    if index == 0 { wins += 1 }
                }
            }

        } else {
            wins = 0
        }
        return wins
        
    }
    
    var losses: Int {
        
        if playerMatchCount != 0 {
            return playerMatchCount - self.wins
        } else {
            return 0
        }
    }
}
