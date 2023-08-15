//
//  LeaderBoardRowView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/14/23.
//

import SwiftUI

struct LeaderBoardRowView: View {
    let playerRecord: PlayerRecord
    
    var body: some View {
        GridRow {
            Text(playerRecord.player.name)
                .gridColumnAlignment(.leading)
            //                .font(.title2)
            //                .fontWeight(.bold)
            
            Text("Wins: \(playerRecord.wins)")
            Text("Losses: \(playerRecord.losses)")
//            .padding()
        }
        .padding()
//        Divider()
//        .padding()
    }
}

struct LeaderBoardRowView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardRowView(playerRecord: PlayerRecord(game: .cascadia, player: Player.samplePlayers[0], matches: HistoricalMatch.sampleData))
    }
}
