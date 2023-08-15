//
//  PlayerScoreEntryRow.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/19/23.
//

import SwiftUI

struct PlayerScoreEntryRow: View {
//    @EnvironmentObject var viewModel: ViewModel
    @Binding var score: Score
    @State var playerScoreValue: Int = 0
    
    var body: some View {
        HStack {
            Text(score.player.name)
            Spacer()
            TextField("Score", value: $playerScoreValue, format: .number)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
        }
//        .onSubmit {
//            score.score = playerScoreValue
//        }
//        .onDisappear {
//            score.score = playerScoreValue
//        }
    }
}

struct PlayerScoreEntryRow_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScoreEntryRow(score: .constant(NewMatch.sampleNewMatch.scores[0]))
    }
}