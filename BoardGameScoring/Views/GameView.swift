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
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var newPlayerName = Player(name: "").name
    @State var stepScores: [StepScore] = []
    @State var leaderBoard: [PlayerRecord] = []
    
    let saveAction: ()->Void
        
    var body: some View {
        
        List {
            Section {
                
                if !viewModel.newMatch.players.isEmpty {
                    ForEach(viewModel.newMatch.players) { player in
                        Text(player.name)
                    }
                    .onDelete { indices in
                        viewModel.newMatch.players.remove(atOffsets: indices)
                        leaderBoard = viewModel.getLeaderBoard()
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
                        navigationModel.path.append(GameDestination.matchScore)
                    } else {
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
        .navigationTitle(viewModel.newMatch.game.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // get the leadboard stats
            leaderBoard = viewModel.getLeaderBoard()
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                navigationModel.save()
                saveAction()
            }
        }
    }
}


struct GameView_Previews: PreviewProvider {

    static var previews: some View {
        
        GameView(saveAction: {})
            .environmentObject(DataModel())
            .environmentObject(NavigationModel())
            .environmentObject(ViewModel())

    }
}
