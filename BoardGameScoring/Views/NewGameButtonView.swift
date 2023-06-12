//
//  NewGameButtonView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/12/23.
//

import SwiftUI

struct NewGameButtonView: View {
    var body: some View {
        Text("New Game")
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        
    }
}

struct NewGameButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NewGameButtonView()
    }
}
