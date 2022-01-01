//
//  ContentView.swift
//  ARTracking
//
//  Created by Monyneath Mol on 28/12/21.
//
import SwiftUI
import RealityKit
import ARKit
import AVFoundation


struct ContentView: View {
    
    @State private var isControlVisible : Bool = false
    @State private var showBrowse : Bool = false
    
    @State private var isPlacementEnable = false
    @State private var selectedModel : Model?
    @State private var modelConfirmedForPlacement :  Model?
    
    private var models : [Model] = {
        let fileManager = FileManager.default
        
        guard let path = Bundle.main.resourcePath,
            let files = try? fileManager.contentsOfDirectory(atPath: path) else {return []}
        
        var availableModels: [Model] = []
        
        for filename in files where filename.hasSuffix("usdz") {
            
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            let model = Model(modelName: modelName, category: .chair)
            availableModels.append(model)
        }
        
        return availableModels
    }()
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer(modelConfirmForPlacement: $modelConfirmedForPlacement)
            
            ControlView(isControlVisible: $isControlVisible,
                        showBrowse: $showBrowse)
//            
//            if self.isPlacementEnable {
//                PlacementButtonView(
//                    isPlacementEnabled: $isPlacementEnable,
//                    selectedModel: $selectedModel,
//                    modelConfirmedForPlacement: $modelConfirmedForPlacement)
//            }else {
//                ModelPickerView(isPlacementEnabled: $isPlacementEnable,
//                                selectedModel: $selectedModel,
//                                models: models)
//            }
        }
//        .background(Color.blue)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer : UIViewRepresentable{
    @Binding var modelConfirmForPlacement: Model?
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal,.vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
   
        /*
        if let model = self.modelConfirmForPlacement {
            print("DEBUG: added model : \(model.modelName)")

            if let modelEntity =   model.modelEntity {

                let anchorEntity = AnchorEntity.init(.vertical)

                
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                uiView.scene.addAnchor(anchorEntity)
            }else{
                print("DEBUG: Unable to load Model : \(model.modelName)")
            }

            DispatchQueue.main.async {
                modelConfirmForPlacement = nil
            }
        }
         
         */
    }
} 

struct ModelPickerView: View{
    
    @Binding var isPlacementEnabled : Bool
    @Binding var selectedModel : Model?
    var models: [Model]
    
    var body : some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing:30){
                
                ForEach(0 ..< self.models.count) { index in
                    
                    Button {
                        
//                        isPlacementEnabled = true
                        print("Selected model with name \(models[index])")
                        self.isPlacementEnabled = true
                        self.selectedModel = models[index]
                    } label: {
                        Image(uiImage: models[index].image)
                            .resizable()
                            .frame(height:80.0)
                            .aspectRatio(1/1, contentMode: .fit)
                            .cornerRadius(12.0)
                    }
                    .buttonStyle(PlainButtonStyle())

                }
            }
            
        }
        .padding(20.0)
        .background(Color.black.opacity(0.5))
    }
    
}


struct PlacementButtonView: View{
    
    @Binding var isPlacementEnabled : Bool
    @Binding var selectedModel : Model?
    @Binding var modelConfirmedForPlacement : Model?
    var body: some View {
        HStack{
            //cancel button
            Button {
                print("Cancel Model Palacement")
                resetPlacement()
                
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 60.0, height: 60.0)
                    .background(Color.red.opacity(0.5))
                    .cornerRadius(60.0)
                    .padding(4.0)
                    
            }
            
            // Confirm button
            Button {
                print("enable Model Palacement")
                
                modelConfirmedForPlacement = selectedModel
                resetPlacement()
                
            } label: {
                Image(systemName: "checkmark")
                    .frame(width: 60.0, height: 60.0)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(60.0)
                    .padding(4.0)
                    
            }

        }
    }
    
    
    private func resetPlacement(){
        isPlacementEnabled = false
        selectedModel = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12")
    }
}
