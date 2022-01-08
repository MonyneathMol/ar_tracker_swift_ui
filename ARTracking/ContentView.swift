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
    @EnvironmentObject var placementSettings : PlacementSettings
    @State private var isControlVisible : Bool = true
    @State private var showBrowse : Bool = false
    @State private var isPlacementEnable = false
    
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
//            ARViewContainer(modelConfirmForPlacement: $placementSettings.confirmedSelectedModel)
            ARViewContainer()
            
            
            if placementSettings.selectedModel == nil {
                ControlView(isControlVisible: $isControlVisible,
                            showBrowse: $showBrowse)
            }else {
                PlacementButtonView()
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer : UIViewRepresentable{
    @EnvironmentObject var placementSettings : PlacementSettings
    func makeUIView(context: Context) ->       CustomARView {
        let arView = CustomARView(frame: CGRect.zero)
        
        self.placementSettings.scenceObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { event in
            
            updateScene(for: arView)
        })
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
        
    }
    
    private func updateScene(for arView: CustomARView) {
 
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        if let confirmModelEntity = placementSettings.confirmedSelectedModel, let modelEntity = confirmModelEntity.modelEntity {
             
            place(modelEntity, arView: arView)
            placementSettings.confirmedSelectedModel = nil
        }
        
    }
    
    private func place(_ modelEntity: ModelEntity,arView: ARView){
        
        //1. Clone model entity
        let cloneEntity = modelEntity.clone(recursive: true)
        
        //2. Enable roation and translation to model entity
        cloneEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation,.translation],for: cloneEntity)
        
        //3. Create anchor entity and add clone model to anchor entity
        let anchorEntity = AnchorEntity.init(plane: .any)
        anchorEntity.addChild(cloneEntity)
        
        //4. Add ArView to the scene
        arView.scene.addAnchor(anchorEntity)
        debugPrint("DEBUG:Added entity to the view")
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 12 Pro")
                .environmentObject(PlacementSettings())
        }
    }
}
