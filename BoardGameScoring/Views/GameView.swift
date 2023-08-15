//
//  GameView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/12/23.
//

import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var dataModel: DataModel
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var navigationModel: NavigationModel
    
    @State private var newPlayerName = Player(name: "").name
    @State var stepScores: [StepScore] = []
    @State var leaderBoard: [PlayerRecord] = []
        
    var body: some View {
        
//        NavigationStack(path: $navigationModel.gamePath) {
        NavigationStack(path: $navigationModel.path) {
            List {
                Section {
                    
                    if !viewModel.newMatch.players.isEmpty {
                        ForEach(viewModel.newMatch.players) { player in
                            Text(player.name)
                        }
                        .onDelete { indices in
                            viewModel.newMatch.players.remove(atOffsets: indices)
                        }
                    }
                    
                    HStack {
                        TextField("New Player", text: $newPlayerName)
                        Button {
                            withAnimation {
                                let newPlayer = Player(name: newPlayerName)
                                viewModel.newMatch.players.append(newPlayer)
                                newPlayerName = ""
                                leaderBoard = viewModel.getLeaderBoard()
                            }
                        } label: {
                            Image(systemName: "plus.square.fill")
                                .accessibilityLabel("Add new player")
                        }
                        .disabled(newPlayerName.isEmpty)
                    }
                    
                    Button {
                        if viewModel.newMatch.startingNewMatch {
                            viewModel.initializeNewMatch()
                            viewModel.newMatch.startingNewMatch = false
//                            navigationModel.gamePath.append(.matchScore)
                            navigationModel.path.append(GameDestination.matchScore)
                        } else {
                            viewModel.initializeNewMatch()
//                            navigationModel.gamePath.append(.matchScore)
                            navigationModel.path.append(GameDestination.matchScore)
                        }
                    } label: {
                        if viewModel.newMatch.startingNewMatch {
                            Text("Start New Match")
                        } else {
                            Text("Continue Match")
                        }
                    }.frame(maxWidth: .infinity, alignment: .center)

                    
                } header: {
                    Text("Players")
//                        .font(.title2)
                }
                
                
                Section {
                    if !leaderBoard.isEmpty {
                        Grid {
                            ForEach(leaderBoard) { player in
                                LeaderBoardRowView(playerRecord: player)
                            }
                        }
                    }
                    
                    Button {
                        //Push an object that is a list of historical
                        // matches on the stack.

                    } label: {
                        HStack {
                            Spacer()
                            HistoryButtonView()
                            Spacer()
                        }
                        
                    }
                    
                } header: {
                    Text("Leader Board")
//                        .font(.title2)
                }
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
                    GameView()
                case .stepScore:
                    ScoreEntryView()

                }
                
             }
            .navigationTitle(viewModel.newMatch.game.name.capitalized)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // get the leadboard stats
                leaderBoard = viewModel.getLeaderBoard()
            }
        }
    }
}


struct GameView_Previews: PreviewProvider {

    static var previews: some View {
        
        GameView()
            .environmentObject(DataModel())
            .environmentObject(NavigationModel())
            .environmentObject(ViewModel())

    }
}
