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
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            
            Spacer()
            
            List(Game.allCases) { game in
                
                Button {
                    viewModel.newMatch.game = game
                    navigationModel.path.append(GameDestination.newMatch)

                } label: {
                    GameCardView(game: game)
                }
                .listRowBackground(game.theme.mainColor)
            }
            .navigationDestination(for: GameDestination.self) { destination in
                switch destination {
                case .matchScore:
                    ScoreGameView {
                        Task {
                            do {
                                try await viewModel.save()
                            } catch {
                                fatalError(error.localizedDescription)
                            }
                        }
                    }
                case .matchHistory:
                    Text("Placeholder")
                case .newMatch:
                    GameView {
                        Task {
                            do {
                                try await viewModel.save()
                            } catch {
                                fatalError(error.localizedDescription)
                            }
                        }
                    }
                case .stepScore:
                    ScoreEntryView()

                }
                
             }
            
            .navigationTitle("Score A Game")
        }
        .environmentObject(viewModel)
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                navigationModel.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
        .environmentObject(NavigationModel())
        .environmentObject(DataModel())
    }
    
}
