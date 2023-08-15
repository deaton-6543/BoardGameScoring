//
//  ContentView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/3/23.
//

import SwiftUI

struct GamesView: View {
    
    @EnvironmentObject var dataModel: DataModel
    @EnvironmentObject var navigationModel: NavigationModel
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
//        NavigationStack(path: $navigationModel.gamePath) {
        NavigationStack(path: $navigationModel.path) {
            
            Spacer()
            
            List(Game.allCases) { game in
                
                Button {
                    viewModel.newMatch.game = game
//                    newMatch.matchHistory = dataModel.historicalMatches
//                    navigationModel.gamePath.append(.newMatch)
                    navigationModel.path.append(GameDestination.newMatch)

                } label: {
                    GameCardView(game: game)
                }
                .listRowBackground(game.theme.mainColor)
            }
            
            .navigationDestination(for: GameDestination.self, destination: { _ in
                GameView()
            })
            .navigationTitle("Score A Game")
        }
        .environmentObject(viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
        .environmentObject(NavigationModel())
        .environmentObject(DataModel())
    }
    
}
