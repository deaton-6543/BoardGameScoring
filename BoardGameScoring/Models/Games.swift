//
//  Games.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/3/23.
//

import Foundation
import SwiftUI


enum Game: String, Hashable, Identifiable, Codable, CaseIterable, Comparable {
   
    static func < (lhs: Game, rhs: Game) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    
    case cascadia, wingspan
    
    var id: String { rawValue }
    
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
        
    var steps:  KeyValuePairs<String, String> {
        let cascadiaSteps: KeyValuePairs = ["Bears": "Enter player scores per the rules on the Bears Card.",
                                            "Salmon": "Enter player scores per the rules on the Salmon Card.",
                                            "Foxes": "Enter player scores per the rules on the Foxes Card.",
                                            "Hawks": "Enter player scores per the rules on the Hawks Card.",
                                            "Elk": "Enter player scores per the rules on the Elk Card.",
                                            "Mountains": "Enter the number of tiles in the largest contiguous mountain habitat for each player.\n\nBonus scores will be added automatically to the final score.",
                                            "Water": "Enter the number of tiles in the largest contiguous water habitat for each player.\n\nBonus scores will be added automatically to the final score.",
                                            "Prarie": "Enter the number of tiles in the largest contiguous prarie habitat for each player.\n\nBonus scores will be added automatically to the final score.",
                                            "Desert": "Enter the number of tiles in the largest contiguous desert habitat for each player.\n\nBonus scores will be added automatically to the final score.", "Forest": "Enter the number of tiles in the largest contiguous forest habitat for each player.\n\nBonus scores will be added automatically to the final score.",
                                            "Pine Cones": "Enter the number of pine cones held by each player."]
        let wingspanSteps: KeyValuePairs = ["Bird Cards": "Enter the total of the bird card values played in each habitat.",
                                            "Bonus Cards": "Enter the total score from all completed bonus cards.",
                                            "End of Round Goals": "Enter the score each player recieved for end of round goals as shown on the end of round card.",
                                            "Eggs": "Enter the number of eggs on bird cards for each player.",
                                            "Cached Food": "Enter the number of food tokens cached on birds for each player.",
                                            "Tucked Bird Cards": "Enter the number of bird cards tucked for each player.",
                                            "Forest Nectar": "Enter the number of nectar tokens for each player in the forest habitat.\n\nBonus scores will be added automtically based on the total tokens for each player.",
                                            "Grassland Nectar": "Enter the number of nectar tokens for each player in the grassland habitat.n\nBonus scores will be added automtically based on the total tokens for each player.",
                                            "Wetland Nectar": "Enter the number of nectar tokens for each player in the wetland habitat.n\nBonus scores will be added automtically based on the total tokens for each player."]
        
        switch self {
        case .cascadia:
            return cascadiaSteps
        case .wingspan:
            return wingspanSteps
        }
    }
    
    typealias bonusScoreFunction = (StepScore) -> ([Score], String)
    
    var bonusScoring: [String : bonusScoreFunction] {
        // A dictionary that matches a scoring step with a function to calculate the bonus awarded based on the stepScores.
        // Keys in the bonusScoring dictionary must match the corresponding step name for the game in the steps array above.
        
        switch self {
        case .cascadia:
            return ["Mountains": cascadiaBonusScore, "Water": cascadiaBonusScore, "Prarie": cascadiaBonusScore, "Desert": cascadiaBonusScore, "Forest": cascadiaBonusScore]
        case .wingspan:
            return ["Forest Nectar": wingspanBonusScore, "Grassland Nectar": wingspanBonusScore, "Wetland Nectar": wingspanBonusScore]
        }
    }

}
