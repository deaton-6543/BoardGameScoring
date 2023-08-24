//
//  MainView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/11/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var navigationModel = NavigationModel()
    @StateObject private var dataModel = DataModel.shared
   
    var body: some View {
        TabView(selection: $navigationModel.selectedTab) {
            GamesView()
                .tag(ContentViewTab.games)
                .tabItem {
                    Label("Games", systemImage: "dice")
                }
            PlayersView()
                .tag(ContentViewTab.players)
                .tabItem {
                    Label("Players", systemImage: "person.2")
                }
        }
        .environmentObject(navigationModel)
        .environmentObject(dataModel)
        .task {
            do {
                try await dataModel.load()
            } catch {
                dataModel.historicalMatches = HistoricalMatch.sampleData
                fatalError("There was an error loading historical matches.\nSample data will be loaded")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView().environmentObject(NavigationModel())
    }
}
