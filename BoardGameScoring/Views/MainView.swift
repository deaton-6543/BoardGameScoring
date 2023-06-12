//
//  MainView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/11/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            GamesView()
                .tabItem {
                    Label("Games", systemImage: "dice")
                }
            PlayersView()
                .tabItem {
                    Label("Players", systemImage: "person.2")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
