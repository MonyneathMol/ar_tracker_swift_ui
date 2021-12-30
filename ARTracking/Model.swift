//
//  Model.swift
//  ARTracking
//
//  Created by Monyneath Mol on 29/12/21.
//

import UIKit
import RealityKit
import Combine


class Model {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String){
        self.modelName = modelName
        self.image = UIImage(named: modelName)!
        let fileName = modelName + ".usdz"
        
        cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: { loadCompletion in
                //Error occur here
                print("DEBUG: unable to load entity for model name \(modelName)")
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                print("DEBUG: Success load entity with Model name \(modelName)")
            })
        
    }
}
