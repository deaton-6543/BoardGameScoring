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
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .foregroundColor(game.theme.accentColor)
        
    }
}

struct GameCardView_Previews: PreviewProvider {
    static var game = Game.cascadia
    static var previews: some View {
        GameCardView(game: game)
            .background(game.theme.mainColor)
    }
}

