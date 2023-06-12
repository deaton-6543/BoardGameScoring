//
//  ContentView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/3/23.
//

import SwiftUI

struct GamesView: View {
    
    let games = [cascadia, wingspan]
    
    var body: some View {
        NavigationStack {
            Spacer()
            List(games) { game in
                NavigationLink {
                    // Insert navigation code here
                } label: {
                    GameCardView(game: game)
                }
                .listRowBackground(game.color)
            }
            .navigationTitle("Score A Game")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}
