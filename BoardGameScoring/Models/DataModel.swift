//
//  DataModel.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/29/23.
//

import Foundation
import SwiftUI

class DataModel: ObservableObject, Codable {
    static let shared = DataModel()
    var historicalMatches: [HistoricalMatch] = []
    
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

