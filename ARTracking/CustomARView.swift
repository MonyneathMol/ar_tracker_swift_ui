//
//  CustomARView.swift
//  ARTracking
//
//  Created by Monyneath Mol on 1/1/22.
//

import ARKit
import RealityKit
import FocusEntity


class CustomARView: ARView {
    var focusEntity : FocusEntity?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        focusEntity = FocusEntity(on: self, focus: .classic)
        
        configure()
    }
    
    @MainActor @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal,.vertical]
        
        
        session.run(config)
    }
}
