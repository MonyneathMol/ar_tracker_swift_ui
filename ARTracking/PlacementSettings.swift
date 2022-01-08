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
    
    @Published var confirmedSelectedModel : Model? {
        willSet(newValue){
            guard let model = newValue else{
                debugPrint("DEBUG: Confim model clear")
                return
            }
            print("DEBUG: will set confirmedSelectedModel \(newValue?.modelName ?? "NA")")
            
            recentlyPlaceModels.append(model)
        }
    }
    
    
    @Published var recentlyPlaceModels : [Model] = []
    
    var scenceObserver: Cancellable?
}
