//
//  PlacementSettings.swift
//  ARTracking
//
//  Created by Monyneath Mol on 1/1/22.
//

import SwiftUI
import Combine
import RealityKit


class PlacementSettings : ObservableObject {
    
    
    @Published var selectedModel :  Model? {
        willSet{
            print("DEBUG: will set selected model \( newValue?.modelName ?? "")")
        }
    }
    
    @Published var confirmedSelectedModel :  Model? {
        willSet{
            print("DEBUG: will set confirmedSelectedModel \(newValue?.modelName ?? "")")
        }
    }
    
    var scenceObserver: Cancellable?
}
