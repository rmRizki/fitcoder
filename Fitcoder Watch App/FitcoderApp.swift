//
//  FitcoderApp.swift
//  Fitcoder Watch App
//
//  Created by Rizki Maulana on 15/05/24.
//

import SwiftUI

@main
struct Fitcoder_Watch_App: App {
    @StateObject var healthKitManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager)
        }
    }
}
