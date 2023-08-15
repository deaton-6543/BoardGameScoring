//
//  ScoreGameView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/16/23.
//

import SwiftUI

struct ScoreGameView: View {
    
    @EnvironmentObject var dataModel: DataModel
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var navigationModel: NavigationModel
    @Environment(\.scenePhase) private var scenePhase
//    var scoreStepsComplete: Bool = false
    @State var doneButtonTapped: Bool = false
    @State var presentAlert: Bool  = false

//    @State private var isPresentingScoringStep: Bool = false
    @State private var scoringStep: StepScore = StepScore.emptyStepScore
//    @State private var index: Int = 0
    let saveAction: ()->Void
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.newMatch.scores, id: \.player) { score in
                    PlayerScoreView(playerScore: score)
                }

            } header: {
                Text("Players").font(.title2)
            }

            Section {
                ForEach (viewModel.newMatch.stepScores.indices, id: \.self) { index in
                    ScoringStepButtonView(index: index)
                }
           } header: {
                Text("Scoring Steps").font(.title2)
           }
            Button {
                viewModel.resetMatch()
                withAnimation {
//                    navigationModel.gamePath = []
                    navigationModel.path.removeLast(navigationModel.path.count)
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Abandon Game")
                    Spacer()
                }
            }
        }
        .navigationTitle(viewModel.newMatch.game.name.capitalized)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    doneButtonTapped = true
                    presentAlert = doneButtonTapped && !viewModel.newMatch.scoreStepsComplete
                    if viewModel.newMatch.scoreStepsComplete {
                        // Save the match to historical matches
                        viewModel.saveCompletedMatch()
                        viewModel.resetMatch()
                        withAnimation {
//                            navigationModel.gamePath = []
                            navigationModel.path.removeLast(navigationModel.path.count)
                        }
//                        newMatch.initializeNewMatch()
                    }
                }
                .alert("Are you sure you want to quit and save the game?", isPresented: $presentAlert) {
                    Button {
                        viewModel.saveCompletedMatch()
                        viewModel.resetMatch()
                        withAnimation {
//                            navigationModel.gamePath = []
                            navigationModel.path.removeLast(navigationModel.path.count)
                        }
                        
                    } label: {
                        Text("OK")
                    }
                    Button("Cancel", role: .cancel) { }

                } message: {
                    Text("You have not completed scoring all the end of game steps. Save the match before completing?")
                }

            }
        }

        .sheet(isPresented: $viewModel.isPresentingScoringStep) {
            NavigationStack {
                ScoreEntryView()
            }
            .presentationDetents([.medium, .large])
            
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }

    }
}

struct ScoreGameView_Previews: PreviewProvider {
    static var previews: some View {

        ScoreGameView(saveAction: {})
            .environmentObject(ViewModel())
            .environmentObject(NavigationModel())
            .environmentObject(DataModel())
    }
}

func not(_ value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}


