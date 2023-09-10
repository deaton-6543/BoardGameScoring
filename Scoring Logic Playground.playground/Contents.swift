import Foundation
import SwiftUI
import PlaygroundSupport
import UIKit


enum Theme: String, CaseIterable, Identifiable, Codable {

    case banana
    case blue
    case bubblegum
    case flora
    case indigo
    case orange
    
    var accentColor: Color {
        switch self {
        case .bubblegum, .banana, .flora, .orange: return .black
        case .indigo, .blue: return .white
        }
    }
    var mainColor: Color {
        Color(rawValue)
    }
    var name: String {
        rawValue
    }
    var id: String {
        name
    }
}

struct Player: Codable, Identifiable {
    var name: String
    var id: String {
        self.name
    }
}

extension Player: Hashable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Score: Codable, Identifiable {
    let player: Player
    var score: Int
    var id: Player {
        player
    }
    
    init(player: Player, score: Int) {
        self.player = player
        self.score = score
    }
}


enum Game: Int, Hashable, Identifiable, Codable, CaseIterable {
    
    case cascadia, wingspan
    
    var id: Int { rawValue }
    var name: String {
        switch self {
        case .cascadia: return "Cascadia"
        case .wingspan: return "Wingspan"
        }
    }
    
    var symbol: String {
        switch self {
        case .cascadia: return "fish"
        case .wingspan: return "bird"
        }
    }
    
    var theme: Theme {
        switch self {
        case .cascadia: return .flora
        case .wingspan: return .orange
        }
    }
    
    var steps: [String] {
        switch self {
        case .cascadia:
            return ["Bears", "Salmon", "Foxes", "Hawks", "Elk", "Mountains", "Water", "Prarie", "Desert", "Forest", "Pine Cones"]
        case .wingspan:
            return ["End of Match Bird Cards", "Bird Cards", "Eggs", "End of Round Bonus", "Goal Cards"]
        }
    }
    
    typealias bonusScoreFunction = (inout [Score]) -> String
    
    var bonusScoring: [String : bonusScoreFunction] {
        switch self {
        case .cascadia:
            return ["Mountains": cascadiaBonusScore, "Water": cascadiaBonusScore, "Prarie": cascadiaBonusScore, "Desert": cascadiaBonusScore, "Forest": cascadiaBonusScore]
        case .wingspan:
            return [:]
        }
    }
}

var scores: [Score] = [Score(player: Player(name: "Lisa"), score: 4), Score(player: Player(name: "Sam"), score: 4), Score(player: Player(name: "Tom"), score: 4)]


let myGame: Game = .cascadia
var myFunctions = myGame.bonusScoring
let myFunction = myFunctions["Mountains"]!
print(myFunction(&scores))

//var testScores: [Score] = [Score(player: Player(name: "Sally"), score: 5), Score(player: Player(name: "Pauly"), score: 10)]


struct StepScore: Identifiable, Codable {
    let step: String
    var scores: [Score]
    var isComplete: Bool
    // let scoringText = "Add text to each step that will appear on the scoring screen to tell the user
    // how to calculate the score entry."
    var id: String {
        step
    }
}

extension StepScore: Equatable {
    static func ==(lhs:StepScore, rhs: StepScore) -> Bool {
        lhs.id == rhs.id
    }
}

//var scores: [Score] = [Score(player: Player(name: "Lisa"), score: 0), Score(player: Player(name: "Sam"), score: 4)]

//var scores: [Score] = [Score(player: Player(name: "Sam"), score: 8)]

cascadiaBonusScore(scores: &scores)

func cascadiaBonusScore(scores: inout [Score]) -> String {
    var nWayTie: Int = 0
    var playerNames: [String] = []
    var bonusScoreString: String = ""
    let sortedScores = scores.sorted(by: { $0.score > $1.score })
    let playerCount = scores.count
    
    for index in (1...playerCount) {
        if sortedScores[0].score == sortedScores[index-1].score {
            nWayTie = index
        }
    }
    
    for index in (0...nWayTie-1) {
        playerNames.append(sortedScores[index].player.name)
    }
    
    let joinedNames = ListFormatter.localizedString(byJoining: playerNames)
    
    // If a solo game and tile count >= 7, get a 2 point bonus
    // If a two player match, 2 point bonus for greatest. 1 point bonus if tied.
    // If a 3-4 player game, 3 point bonus for highest, 1 point for next. Ties
    // get one point each and no points for second largest.
    
    if playerCount == 1 {           // Solo game
        if scores[0].score >= 7 {
            bonusScoreString = "You get a 2 point bonus for having 7 or greater tiles in this habitat."
            scores[0].score += 2
        } else {
            bonusScoreString = "No bonus scored for this habitat."
        }
    } else if playerCount == 2 {    // Two player game
        if nWayTie == 1 {
            bonusScoreString = "\(joinedNames) will receive a 2 point bonus."
            let index = scores.firstIndex(where: {$0.player == sortedScores[0].player})!
            scores[index].score += 2
        } else {
            bonusScoreString = "\(joinedNames) will each receive a 1 point bonus."
            let index = scores.firstIndex(where: {$0.player == sortedScores[0].player})!
            let index2 = scores.firstIndex(where: {$0.player == sortedScores[1].player})!
            scores[index].score += 1
            scores[index2].score += 1
        }
    } else {                        // 3-4 player game
        switch nWayTie {
        case 2:                     // two way tie
            bonusScoreString = "\(joinedNames) will each receive a 1 point bonus."
            let index = scores.firstIndex(where: {$0.player == sortedScores[0].player})!
            let index2 = scores.firstIndex(where: {$0.player == sortedScores[1].player})!
            scores[index].score += 1
            scores[index2].score += 1
        case 3:                     // three way tie
            bonusScoreString = "\(joinedNames) will each receive a 1 point bonus."
            for sortedIndex in 0...2 {
                let index = scores.firstIndex(where: {$0.player == sortedScores[sortedIndex].player})!
                scores[index].score += 1
            }
        case 4:                     // four way tie
            bonusScoreString = "\(joinedNames) will each receive a 1 point bonus."
            for sortedIndex in 0...3 {
                let index = scores.firstIndex(where: {$0.player == sortedScores[sortedIndex].player})!
                scores[index].score += 1
            }
        default:                    // No ties
            bonusScoreString = "\(joinedNames) will receive a 3 point bonus.\n\(sortedScores[1].player.name) will receive a 1 point bonus."
            let index = scores.firstIndex(where: {$0.player == sortedScores[0].player})!
            let index2 = scores.firstIndex(where: {$0.player == sortedScores[1].player})!
            scores[index].score += 3
            scores[index2].score += 1
        }
    }
//    print(bonusScoreString)
//    for score in scores {
//        print("\(score.player.name): \(score.score)")
//    }
    return bonusScoreString
}



struct TestView: View {
    @State var playerScoreValues: [Int] = [0, 0, 0, 0, 0, 0]
    let bonusScoringAction: ()-> String
    
    var body: some View {
        VStack {
            List {
                ForEach(scores.indices, id: \.self) { index in
                    HStack {
                        Text(scores[index].player.name)
                        Spacer()
                        TextField("Score", value: $playerScoreValues[index], format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            Button("Done") {
                // Create a scores array from the entered scores
                // Supply the scores array as a parameter to the bonus scoring closure
                // Show the string returned by the bonusScoring function
            }
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView { cascadiaBonusScore(scores: &scores) }
    }
}

let testView = TestView { cascadiaBonusScore(scores: &scores) }

PlaygroundPage.current.setLiveView(testView)
