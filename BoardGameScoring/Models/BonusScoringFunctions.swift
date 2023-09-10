//
//  BonusScoringFunctions.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 9/4/23.
//

import Foundation


//MARK: Cascadia Bonus Scoring Function

/// Bonus scoing method for Cascadia
/// - Parameter stepScore: a struct that describes the step being scored and contains an array of player scores for the step
/// - Returns: the bonus scores array conainting the bonus scores calculated for each player and a string that describes the calculated bonus scores
func cascadiaBonusScore(stepScore: StepScore) -> (bonusScores: [Score], bonusString: String) {
    var nWayTie: Int = 0
    var playerNames: [String] = []
    var bonusScoreString: String = ""
    var bonusScores: [Score] = []
    
    let scores = stepScore.scores
    let sortedScores = scores.sorted(by: {$0.score! > $1.score!})
    let playerCount = scores.count
    
    // Check to see how many players have the same score as the top score
    for index in (1...playerCount) {
        if sortedScores[0].score == sortedScores[index-1].score {
            nWayTie = index
        }
    }
    
    // Gather the names of the players tied for top score in a sring and format the string
    for index in (0...nWayTie-1) {
        playerNames.append(sortedScores[index].player.name)
    }
    let joinedNames = ListFormatter.localizedString(byJoining: playerNames)
    
    // If a solo game and tile count >= 7, get a 2 point bonus
    // If a two player match, 2 point bonus for greatest. 1 point bonus if tied.
    // If a 3-4 player game, 3 point bonus for highest, 1 point for next. Ties
    // get one point each and no points for second largest.
        
    // Initialize the bonusScores array from the scores in the stepScore
    bonusScores = scores
    for index in (0...playerCount - 1) {
        bonusScores[index].score = 0
    }
    
    if playerCount == 1 {           // Solo game
        if scores[0].score! >= 7 {
            bonusScoreString = "You earned a 2 point bonus for having 7 or greater tiles in this habitat."
            bonusScores[0].score = 2
        } else {
            bonusScoreString = "No bonus awarded for this habitat."
        }
    } else if playerCount == 2 {    // Two player game
        if nWayTie == 1 {
            bonusScoreString = "\(joinedNames) was awarded a 2 point bonus."
            let index = bonusScores.firstIndex(where: {$0.player == sortedScores[0].player})!
            bonusScores[index].score = 2
        } else {
            bonusScoreString = "\(joinedNames) each received a 1 point bonus."
            let index = bonusScores.firstIndex(where: {$0.player == sortedScores[0].player})!
            let index2 = bonusScores.firstIndex(where: {$0.player == sortedScores[1].player})!
            bonusScores[index].score = 1
            bonusScores[index2].score = 1
        }
    } else {                        // 3-4 player game
        switch nWayTie {
        case 2:                     // two way tie
            bonusScoreString = "\(joinedNames) each received a 1 point bonus."
            let index = bonusScores.firstIndex(where: {$0.player == sortedScores[0].player})!
            let index2 = bonusScores.firstIndex(where: {$0.player == sortedScores[1].player})!
            bonusScores[index].score = 1
            bonusScores[index2].score = 1
        case 3:                     // three way tie
            bonusScoreString = "\(joinedNames) each received a 1 point bonus."
            for sortedIndex in 0...2 {
                let index = bonusScores.firstIndex(where: {$0.player == sortedScores[sortedIndex].player})!
                bonusScores[index].score = 1
            }
        case 4:                     // four way tie
            bonusScoreString = "\(joinedNames) each received a 1 point bonus."
            for sortedIndex in 0...3 {
                let index = bonusScores.firstIndex(where: {$0.player == sortedScores[sortedIndex].player})!
                bonusScores[index].score = 1
            }
        default:                    // No ties
            bonusScoreString = "\(joinedNames) each received a 3 point bonus.\n\(sortedScores[1].player.name) will receive a 1 point bonus."
            let index = bonusScores.firstIndex(where: {$0.player == sortedScores[0].player})!
            let index2 = bonusScores.firstIndex(where: {$0.player == sortedScores[1].player})!
            bonusScores[index].score = 3
            bonusScores[index2].score = 1
        }
    }
    return (bonusScores, bonusScoreString)
}

//MARK: Wingspan Bonus Scoring Function

/// Bonus Scoring Method for Wingspan
/// - Parameter stepScore: a struct that describes the step being scored and contains an array of player scores for the step
/// - Returns: the bonus scores array conainting the bonus scores calculated for each player and a string that describes the calculated bonus scores
func wingspanBonusScore(stepScore: StepScore) -> (bonusScores: [Score], bonusString: String) {
    var nWayTieForFirstPlace: Int = 0           // Number of players that have tied for first place
    var nWayTieForSecondPlace: Int = 0          // NUmber of players that have tied for second place
//    var secondPlaceIndex: Int = 0               // Index in the sorted scores where second place starts
    var playerNames: [String] = []
    var bonusScoreString: String = ""
    var bonusScores: [Score] = []
    var firstPlaceBonus: Int = 0
    var secondPlaceBonus: Int = 0
    let bonusPoints = [5, 2, 0, 0, 0, 0]        //The number of bonus points available by position for nectar
    var totalFirstPlacePoints: Int = 0
    var totalSecondPlacePoints: Int = 0
    var secondPlaceString: String = ""
    
    let scores = stepScore.scores
    let sortedScores = scores.sorted(by: {$0.score! > $1.score!})
    let playerCount = scores.count
    
    // Initialize the bonusScores array from the scores in the stepScore
    bonusScores = scores
    for index in (0...playerCount - 1) {
        bonusScores[index].score = 0
    }
    
    // Check to see how many players have the same score as the top score
    for index in (1...playerCount) {
        if sortedScores[0].score == sortedScores[index - 1].score {
            nWayTieForFirstPlace = index
        }
    }
    
    // Determine there is a second place
    // If so, find the second place score and then check to see how many players have that score
    // Find the index in the sorted scores where second place starts
    // Create the bonus scoring string for second place
    if let secondPlaceScore = sortedScores.first(where: { $0.score! < sortedScores[0].score! }), let secondPlaceIndex = sortedScores.firstIndex(where: { $0.score! < sortedScores[0].score! }) {
        for index in (1...playerCount) {
            if secondPlaceScore.score == sortedScores[index - 1].score {
                nWayTieForSecondPlace = index - nWayTieForFirstPlace
            }
        }
        
        // Calculate the bonus score for second place
        if nWayTieForFirstPlace >= 2 {      // The players tied for first are dividing all available bonus points
            totalSecondPlacePoints = 0
        } else {
            totalSecondPlacePoints = 2      // Only two points are available to share with players tied for second place
            secondPlaceBonus = Int((Double(totalSecondPlacePoints) / Double(nWayTieForSecondPlace)).rounded(.down))
            
            // Assign the bonus score to the second place players
            for index in (secondPlaceIndex...secondPlaceIndex + nWayTieForSecondPlace - 1) {
                let bonusScoreIndex = bonusScores.firstIndex(where: { $0.player == sortedScores[index].player })!
                bonusScores[bonusScoreIndex].score = secondPlaceBonus
            }
            
            // Gather the names of the players tied for second place in a string and format the string
            playerNames = []
            if let secondPlaceIndex = sortedScores.firstIndex(where: { $0.score! < sortedScores[0].score! }) {
                for index in (secondPlaceIndex...secondPlaceIndex + nWayTieForSecondPlace - 1) {
                    playerNames.append(sortedScores[index].player.name)
                }
            }
            let joinedNamesForSecondPlace = ListFormatter.localizedString(byJoining: playerNames)
            secondPlaceString = "\n\(joinedNamesForSecondPlace) received a bonus of \(secondPlaceBonus) points."

        }
        
        // Assign the bonus score to the second place players
        for index in (secondPlaceIndex...secondPlaceIndex + nWayTieForSecondPlace - 1) {
            let bonusScoreIndex = bonusScores.firstIndex(where: { $0.player == sortedScores[index].player })!
            bonusScores[bonusScoreIndex].score = secondPlaceBonus
        }
    }
    
    // Gather the names of the players tied for top score in a sring and format the string
    playerNames = []
    for index in (0...nWayTieForFirstPlace - 1) {
        playerNames.append(sortedScores[index].player.name)
    }
    let joinedNamesForFirstPlace = ListFormatter.localizedString(byJoining: playerNames)
        
    // Player nectar bonus is determined by the number of players tied for a place divided
    // by the number of players tied for that place and then rounded down.
    // The bonus scores are calculated by the positions they occupy (first or second).
    // First position is 5 points, second position is 2 points.
 
    // Calculate the bonus score for first place
    if nWayTieForFirstPlace == 1 {
        totalFirstPlacePoints = 5
    } else {
        for index in (0...nWayTieForFirstPlace - 1) {
            totalFirstPlacePoints += bonusPoints[index]
        }
    }
    firstPlaceBonus = Int((Double(totalFirstPlacePoints) / Double(nWayTieForFirstPlace)).rounded(.down))
    
    // Assign the bonus score to the first place players
    for index in (0...nWayTieForFirstPlace - 1) {
        let bonusScoreIndex = bonusScores.firstIndex(where: { $0.player == sortedScores[index].player })!
        bonusScores[bonusScoreIndex].score = firstPlaceBonus
    }

    bonusScoreString = "\(joinedNamesForFirstPlace) recieved a bonus of \(firstPlaceBonus) points." + secondPlaceString
    
    return (bonusScores, bonusScoreString)
}
