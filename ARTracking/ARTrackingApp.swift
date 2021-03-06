//
//  ARTrackingApp.swift
//  ARTracking
//
//  Created by Monyneath Mol on 28/12/21.
//

import SwiftUI

@main
struct ARTrackingApp: App {
    
    @StateObject var placementSettings = PlacementSettings()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(placementSettings)
        }
    }
}
