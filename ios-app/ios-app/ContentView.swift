//
//  ContentView.swift
//  ios-app
//
//  Created by Tabitha on 9/26/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cardProvider: CardProvider
    var body: some View {
        VStack {
            Text("Welcome to Flashcards!")
            Text("")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
