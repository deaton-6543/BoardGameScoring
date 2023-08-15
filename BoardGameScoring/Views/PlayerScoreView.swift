//
//  PlayerScoreView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/18/23.
//

import SwiftUI

struct PlayerScoreView: View {
    let playerScore: Score

    var body: some View {
        HStack {
            Text(playerScore.player.name)
            Spacer()
            Text(String(playerScore.score))
        }
    }
}

struct PlayerScoreView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScoreView(playerScore: NewMatch.sampleNewMatch.scores[0])
    }
}
