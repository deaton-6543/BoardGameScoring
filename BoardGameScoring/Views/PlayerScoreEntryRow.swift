//
//  PlayerScoreEntryRow.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/19/23.
//

import SwiftUI

struct PlayerScoreEntryRow: View {
    var score: Score
    @Binding var playerScoreValue: Int?
    
    var body: some View {
        HStack {
            Text(score.player.name)
            Spacer()
            TextField("Score", value: $playerScoreValue, format: .number)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            
                        }
                    }
                }
        }
    }
}

struct PlayerScoreEntryRow_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScoreEntryRow(score: NewMatch.sampleNewMatch.scores[0], playerScoreValue: .constant(nil))
    }
}
