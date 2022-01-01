//
//  Model.swift
//  ARTracking
//
//  Created by Monyneath Mol on 29/12/21.
//

import UIKit
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
    case table
    case chair
    case decor
    case light
    
    var label : String {
        get{
            switch self{
                
            case .table:
                return "Tables"
            case .chair:
                return "Chairs"
            case .decor:
                return "Decores"
            case .light:
                return "Lights"
            }
        }
    }
}


class Model {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    var category : ModelCategory
    var scaleCompensation: Float
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String,category : ModelCategory,scaleCompensation: Float = 1.0){
        self.modelName = modelName
        self.category = category
        self.scaleCompensation = scaleCompensation
        
        self.image = UIImage(named: modelName) ?? UIImage(systemName: "photo")!
        
    }
    
    func asyncLoadEntity() {
        
        let fileName = modelName + ".usdz"
        cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: { loadCompletion in
                //Error occur here
                switch loadCompletion {
                case .failure(let error) :
                    print("DEBUG: error occure \(error.localizedDescription)")
                case .finished:
                    print("DEBUG: Load finished")
                }
                
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                print("DEBUG: Success load entity with Model name \(self.modelName)")
            })
    }
}


struct Models {
    
    var all : [Model] = []
    
    init(){
        
        for i in 0...4 {
            let chair = Model(modelName: "chair_swan", category: .chair,scaleCompensation: Float(i/10))
            all += [chair]
        }
        

        for i in 0...2 {
            let chair = Model(modelName: "toy_char", category: .decor,scaleCompensation: Float(i/10))
            all += [chair]
        }
        
        for i in 0...3 {
            let chair = Model(modelName: "toy_drummer", category: .table,scaleCompensation: Float(i/10))
            all += [chair]
        }
        
        for i in 0...2 {
            let chair = Model(modelName: "toy_drummer", category: .light,scaleCompensation: Float(i/10))
            all += [chair]
        }
    }
    
    func get(category : ModelCategory) -> [Model]{
        return all.filter({$0.category == category})
    }
} 
