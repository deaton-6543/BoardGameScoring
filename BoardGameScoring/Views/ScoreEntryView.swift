//
//  ScoreEntryView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/20/23.
//

import SwiftUI

struct ScoreEntryView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var playerScoreValues: [Int?] = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
//    @State var playerScoreValues: [Int?] = []

    

    var body: some View {
        let stepScoreindex = viewModel.stepScoreIndex
        let playerScores = viewModel.newMatch.stepScores[stepScoreindex].scores
        
        List {
            ForEach(playerScores.indices, id: \.self) { index in
                
//                PlayerScoreEntryRow(score: playerScores[index], playerScoreValue: $playerScoreValues[index])
                
                HStack {
                    Text(playerScores[index].player.name)
                    Spacer()
                    TextField("Score", value: $playerScoreValues[index], format: .number)
                        .keyboardType(.numberPad)
                        .frame(width: 200)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                }
            }
            Text(viewModel.newMatch.stepScores[stepScoreindex].stepText)
                .multilineTextAlignment(.center)
         }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Cancel") {
                    viewModel.isPresentingScoringStep = false
                }
                
                Spacer()
                
                Button("Done") {
                    viewModel.isPresentingScoringStep = false
                    viewModel.newMatch.stepScores[viewModel.stepScoreIndex].isComplete = true
                    viewModel.updateStepScores(scoreValues: playerScoreValues)
                    viewModel.updateBonusScore(stepScore: viewModel.newMatch.stepScores[viewModel.stepScoreIndex])
                    viewModel.totalScores()
                }
                
            }
//            ToolbarItem(placement: .keyboard) {
//                Button("Done") {
//                    viewModel.isPresentingScoringStep = false
//                    viewModel.newMatch.stepScores[viewModel.stepScoreIndex].isComplete = true
//                    viewModel.updateStepScores(scoreValues: playerScoreValues)
//                    viewModel.updateBonusScore(stepScore: viewModel.newMatch.stepScores[viewModel.stepScoreIndex])
//                    viewModel.totalScores()
//                }
//            }
//            ToolbarItem(placement: .keyboard) {
//                Button("Cancel") {
//                    viewModel.isPresentingScoringStep = false
//                }
//            }
        }

        .navigationTitle(viewModel.newMatch.stepScores[viewModel.stepScoreIndex].step)
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Done") {
//                        viewModel.isPresentingScoringStep = false
//                        viewModel.newMatch.stepScores[viewModel.stepScoreIndex].isComplete = true
//                        viewModel.updateStepScores(scoreValues: playerScoreValues)
//                        viewModel.updateBonusScore(stepScore: viewModel.newMatch.stepScores[viewModel.stepScoreIndex])
//                        viewModel.totalScores()
//                    }
//                }
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        viewModel.isPresentingScoringStep = false
//                    }
//                }
//            }
            .onAppear {
                initializeScores()
            }
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
