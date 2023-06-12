//
//  GameView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/12/23.
//

import SwiftUI

struct GameView: View {
    let game: Game
    @State private var newPlayerName = Player(name: "").name
    
    var body: some View {
        var players: [Player] = getPlayers() ?? [] //get the players from the last game
        Form {
            Section("Players") {
                if !players.isEmpty {
                    ForEach(players) { player in
                        Text(player.name)
                    }
                    .onDelete { indices in
                        players.remove(atOffsets: indices)
                    }
                }
                HStack {
                    TextField("New Player", text: $newPlayerName)
                    Button {
                        withAnimation {
                            let newPlayer = Player(name: newPlayerName)
                            players.append(newPlayer)
                            newPlayerName = ""
                        }
                    } label: {
                        Image(systemName: "plus.square.fill")
                            .accessibilityLabel("Add new player")
                    }
                    .disabled(newPlayerName.isEmpty)
                }
            }
            
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    NewGameButtonView()
                    Spacer()
                }

            }

        }
 
     }
    
    func getPlayers() -> [Player]? {
        var players: [Player] = []
        let matches = Match.sampleData.sorted { $0.date > $1.date }
        
        guard let lastMatch = matches.first else {return nil}
        for player in lastMatch.scores.keys {
            players.append(player)
        }
        return players
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: cascadia)
    }
}
