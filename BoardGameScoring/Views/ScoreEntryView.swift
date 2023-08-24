//
//  ScoreEntryView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/20/23.
//

import SwiftUI

struct ScoreEntryView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var playerScoreValues: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    

    var body: some View {
        let stepScoreindex = viewModel.stepScoreIndex
        let playerScores = viewModel.newMatch.stepScores[stepScoreindex].scores
        
        List {
            ForEach(playerScores.indices, id: \.self) { index in
                HStack {
                    Text(playerScores[index].player.name)
                    Spacer()
                    TextField("Score", value: $playerScoreValues[index], format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                }
            }
         }
        .navigationTitle(viewModel.newMatch.stepScores[viewModel.stepScoreIndex].step)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        viewModel.isPresentingScoringStep = false
                        viewModel.newMatch.stepScores[viewModel.stepScoreIndex].isComplete = true
                        viewModel.updateStepScores(scoreValues: playerScoreValues)
                        viewModel.totalScores()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.isPresentingScoringStep = false
                        
                        // need code to set the scores to zero if the .isComplete bool
                        // is false when the cancel button was selected.
                        
                    }
                }
            }
            .onAppear {
                initializeScores()
            }
    }
    
    // This method is not currently used
    func initializePlayerScores() -> [Int] {
        var scoreValues: [Int] = []
        for score in viewModel.newMatch.stepScores[viewModel.stepScoreIndex].scores {
            scoreValues.append(score.score)
        }
        return scoreValues
    }
    
    func initializeScores() {
        
        playerScoreValues = viewModel.newMatch.stepScores[viewModel.stepScoreIndex].scores.map { $0.score }
        
    }
}

struct ScoreEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreEntryView()
            .environmentObject(ViewModel())
    }
}
