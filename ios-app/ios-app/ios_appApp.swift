//
//  ios_appApp.swift
//  ios-app
//
//  Created by Tabitha on 9/26/24.
//

import SwiftUI

@main
struct ios_appApp: App {
    @StateObject var quakesProvider = CardProvider()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
