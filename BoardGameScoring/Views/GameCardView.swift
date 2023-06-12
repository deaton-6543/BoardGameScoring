//
//  GameCardView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/11/23.
//

import SwiftUI

struct GameCardView: View {
    let game: Game
    var body: some View {
        HStack {
            Image(systemName: game.symbol)
                .font(.largeTitle)
            Text(game.name)
                .font(.title3)
                .accessibilityLabel(game.name)
        }
        .padding()
        .foregroundColor(.secondary) // add logic to pick a forground color based on the background color of the cell/game
        
    }
}

struct GameCardView_Previews: PreviewProvider {
    static var previews: some View {
        GameCardView(game: cascadia)
    }
}

