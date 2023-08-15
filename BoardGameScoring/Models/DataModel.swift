//
//  DataModel.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/29/23.
//

import Foundation
import SwiftUI

//protocol DataModelable: ObservableObject {
//    var historicalMatches: [HistoricalMatch] { get set }
//    var newMatch: NewMatch? { get set }
//}
//@MainActor
class DataModel: ObservableObject, Codable {
    static let shared = DataModel()
    
//    @Published var historicalMatches: [HistoricalMatch] = []       // HistoricalMatch.sampleData
    var historicalMatches: [HistoricalMatch] = []
//    @Published var newMatch: NewMatch?
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("historicalMatchScores.data")
    }
    
    func load() async throws {
        let task = Task<[HistoricalMatch], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let historicalMatches = try JSONDecoder().decode([HistoricalMatch].self, from: data)
            return historicalMatches
        }
        let historicalMatches = try await task.value
        self.historicalMatches = historicalMatches
    }
    
    func save(completedMatch: HistoricalMatch) async throws {
        historicalMatches.append(completedMatch)
        let task = Task {
            let data = try JSONEncoder().encode(historicalMatches)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }

}

//class PreviewDataModel: DataModel {
//    @Published var historicalMatches: [HistoricalMatch] = HistoricalMatch.sampleData
//    @Published var newMatch: NewMatch?
//}


