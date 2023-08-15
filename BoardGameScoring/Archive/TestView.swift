//
//  TestView.swift
//  BoardGameScoring
//
//  Created by Dennis Eaton on 6/12/23.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, world!")
                .alignmentGuide(.leading) { d in d[.trailing] }
            Text("This is a longer line of text")
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
