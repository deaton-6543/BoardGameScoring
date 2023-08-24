//
//  ScoringStepButtonView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 7/17/23.
//

import SwiftUI

struct ScoringStepButtonView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let index: Int
    
    var body: some View {
        Button {
            viewModel.stepScoreIndex = index
            viewModel.isPresentingScoringStep = true
        } label: {
            HStack{
                Image(systemName: viewModel.newMatch.stepScores[index].isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.blue)
                Text(viewModel.newMatch.stepScores[index].step)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .font(.headline)
        .buttonStyle(.plain)
    }
}

struct ScoringStepButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ScoringStepButtonView(index: 0)
            .environmentObject(ViewModel())
    }
}
