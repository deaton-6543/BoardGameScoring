//
//  BonusScoreRowView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 9/4/23.
//

import SwiftUI

struct BonusScoreRowView: View {
    
    let bonusName: String
    let bonusScoreInfo: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(bonusName)
                .font(.headline)
            if !bonusScoreInfo.isEmpty {
                Text(bonusScoreInfo)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct BonusScoreRowView_Previews: PreviewProvider {
    static var previews: some View {
        BonusScoreRowView(bonusName: "Mountains Bonus", bonusScoreInfo: "Tom earned 2 bonus points.")
    }
}
