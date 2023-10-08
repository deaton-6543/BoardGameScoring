import UIKit

struct Player: Codable, Identifiable {
    var name: String
    var id: String {
        self.name
    }
}

let players: [Player] = [Player(name: "Sam"), Player(name: "Tim"), Player(name: "Joe")]

let sortedPlayers = players.sorted(by: { $0.name < $1.name })
let playerString = sortedPlayers.compactMap({ $0.name }).reduce("", { s1, s2 in
    s1 + s2
})
print(playerString)
