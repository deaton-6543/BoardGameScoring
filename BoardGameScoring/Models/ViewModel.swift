//
//  Match.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/3/23.
//

import Foundation

//@MainActor 
class ViewModel: Identifiable, ObservableObject {
    
    @Published var newMatch = NewMatch.shared
    @Published var stepScoreIndex: Int = 0
    @Published var isPresentingScoringStep: Bool = false
    
    // Restore a match in progress if the app state was previously saved, else start a new match
    init() {
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("matchInProgress.data")
            let data = try Data(contentsOf: fileURL)
            newMatch = try JSONDecoder().decode(NewMatch.self, from: data)
        } catch {
            newMatch = NewMatch.shared
        }
    }

    func initializeNewMatch() {

        newMatch.scores = []
        newMatch.stepScores = []
        
        // Initialize the scores array with the list of players
        for player in newMatch.players {
            newMatch.scores.append(Score(player: player, score: nil))
        }
    
        // Initialize the stepScores for each step in the game
        for step in newMatch.game.steps {
            newMatch.stepScores.append(StepScore(step: step.key, stepText: step.value, scores: newMatch.scores, isComplete: false))
        }
        
        // Intialize the list of bonusScores for the game
        for bonus in newMatch.game.bonusScoring.keys {
            newMatch.bonusScores.append(BonusScore(bonus: bonus))
        }
    }
        
    func getLeaderBoard() -> [PlayerRecord] {
        var leaderBoard: [PlayerRecord] = []
        
        guard !newMatch.players.isEmpty else { return [] }
        for player in newMatch.players {
            leaderBoard.append(PlayerRecord(game: newMatch.game, player: player, matches: DataModel.shared.historicalMatches))
        }
        leaderBoard.sort { $0.wins > $1.wins }
        return leaderBoard
    }
    
    func updateStepScores(scoreValues: [Int?]) {
        var unwrappedScoreValues: [Int] = []
        for index in scoreValues.indices {
            if let value = scoreValues[index] {
                unwrappedScoreValues.append(value)
            } else {
                unwrappedScoreValues.append(0)
            }
        }
    
        for index in newMatch.stepScores[stepScoreIndex].scores.indices {
            newMatch.stepScores[stepScoreIndex].scores[index].score = unwrappedScoreValues[index]
        }
    }
    
    func updateBonusScore(stepScore: StepScore) {
        guard let index = newMatch.bonusScores.firstIndex(where: { $0.bonus == stepScore.step }) else { return }
        
        // Call the bonus function and calculate the bonus score and the associated string description
        let bonusScoreValues = newMatch.game.bonusScoring[newMatch.bonusScores[index].bonus]!(stepScore)
        newMatch.bonusScores[index].bonusScores = bonusScoreValues.0 // update with the bonus scores
        newMatch.bonusScores[index].bonusScoreString = bonusScoreValues.1 // update with the bonus string
    }
    
    func totalScores() {
        var scoresTotal: [Score] = newMatch.scores
        
        // Clear any existing score
        for index in scoresTotal.indices {
            scoresTotal[index].score = 0
        }
        
        // Accumulate over the stepScores
        for stepScore in newMatch.stepScores {
            for score in stepScore.scores {
                if let index = scoresTotal.firstIndex(where: { $0.player == score.player }) {
                    if let playerScore = score.score {
                        scoresTotal[index].score! += playerScore
                    }
                }
            }
        }
        
        // Accumulate the bonus scores
        for bonusScore in newMatch.bonusScores {
            for score in bonusScore.bonusScores {
                if let index = scoresTotal.firstIndex(where: { $0.player == score.player}) {
                    if let playerScore = score.score {
                        scoresTotal[index].score! += playerScore
                    }
                }
            }
        }
        newMatch.scores  = scoresTotal
    }
    
    func resetMatch() {
        deleteNewMatchFile()
        newMatch.resetNewMatch()
    }
    
    func ScoreStepsComplete() -> Bool {
        let numberOfSteps = newMatch.stepScores.count
        let stepsCompleted = newMatch.stepScores.filter({ $0.isComplete }).count
        return numberOfSteps == stepsCompleted
    }
    
    func saveCompletedMatch() {
        let completedMatch = HistoricalMatch(date: Date(), game: newMatch.game.name, scores: newMatch.scores)
        Task {
            do {
                try await DataModel.shared.save(completedMatch: completedMatch)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("matchInProgress.data")
    }
    
    // Not currently used
    func load() async throws {
        let task = Task<NewMatch, Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return NewMatch.shared  // return a new NewMatch if one is not found
            }
            let matchInProgress = try JSONDecoder().decode(NewMatch.self, from: data)
            return matchInProgress
        }
        let restoredNewMatch = try await task.value
        newMatch = restoredNewMatch
    }
    
    func deleteNewMatchFile() {
        
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("matchInProgress.data")
            try FileManager().removeItem(at: fileURL)
        } catch let error as NSError {
            print("Error deleting newMatch file: \(error)")
        }
    }
    
    func save() async throws {
        let task = Task {
            let data = try JSONEncoder().encode(newMatch)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }

}

