//
//  PlacementView.swift
//  ARTracking
//
//  Created by Monyneath Mol on 1/1/22.
//

import SwiftUI


struct PlacementButtonView: View{
    
    @EnvironmentObject var placementSettings: PlacementSettings
    var body: some View {
        HStack{
            //cancel button
            PlacementButton(action: {
                print("Cancel Model Palacement")
                resetPlacement()
            }, systemIconName: "xmark")
           
            
            // Confirm button
            
            PlacementButton(action: {
                print("enable Model Palacement")
                
//                modelConfirmedForPlacement = selected
                placementSettings.confirmedSelectedModel = placementSettings.selectedModel
                resetPlacement()
            }, systemIconName: "checkmark")
           

        }
    }
    
    
    private func resetPlacement(){
//        isPlacementEnabled = false
        
        placementSettings.selectedModel = nil
    }
}


struct PlacementButton: View {
    var action: ()->Void
    var systemIconName : String
    
    var body: some View{
        Button {
           action()
        } label: {
            Image(systemName: systemIconName)
                .frame(width: 60.0, height: 60.0)
                .background(Color.white.opacity(0.5))
                .cornerRadius(60.0)
                .padding(4.0)
                
        }
    }
}
