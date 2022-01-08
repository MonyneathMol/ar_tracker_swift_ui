//
//  BrowseView.swift
//  ARTracking
//
//  Created by Monyneath Mol on 30/12/21.
//

import SwiftUI

struct BrowseView: View {
    @Binding var showBrowse : Bool
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false, content: {
                MostRecentlyGrid(showBrowse: $showBrowse)
                HorizontalByCategoryGrid(showBrowse: $showBrowse)
            })
            
                .navigationTitle("BrowserView")
                .navigationBarItems(trailing:
                                        Button(action: {
                    print("BACK")
                    showBrowse.toggle()
                }, label: {
                    Image(systemName: "xmark")
                }) )
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    @State static var isShowing = false
    static var previews: some View {
        BrowseView(showBrowse:$isShowing)
        
    }
}


struct MostRecentlyGrid: View {
    @EnvironmentObject var placementSettings : PlacementSettings
    @Binding var showBrowse : Bool
    
    var body: some View {
        
        if !placementSettings.recentlyPlaceModels.isEmpty {
            
            HorizontalGrid(showBrowse: $showBrowse, title: "Recently Item", items: getUniqueRecentModels())
        }
    }
    
    
    func getUniqueRecentModels() -> [Model] {
        var mostlyUniqueModel : [Model] = []
        var modelSetName : Set<String> = []
        
        for model in placementSettings.recentlyPlaceModels.reversed() {
            
            if !modelSetName.contains(model.modelName) {
                
                mostlyUniqueModel.append(model)
                modelSetName.insert(model.modelName)
                
            }
            
        }
        
        
        return mostlyUniqueModel
        
    }
}

struct HorizontalByCategoryGrid : View {
    @Binding var showBrowse : Bool
    let models = Models()
    
    var body: some View {
        VStack {
            
            ForEach(ModelCategory.allCases,id:\.self) { category in
                if let modelCategory = models.get(category:  category) {
                    //Update horizontalgrid here
                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: modelCategory)
                }
                
            }
            
        }
    }
}

struct HorizontalGrid: View{
    @EnvironmentObject var placementSettings : PlacementSettings
    @Binding var showBrowse : Bool
    var title : String
    var items: [Model]
    private let gridItemLayout = [GridItem(.fixed(150.0))]
    var body: some View {
        VStack(alignment:.leading){
            
            Seperater()
            
            Text(title)
                .font(.title2).bold()
                .padding(.leading, 20)
                .padding(.top,10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItemLayout,spacing: 30.0) {
                    
                    
                    ForEach(0..<items.count){ index in
                        let model = items[index]
                        ItemButton(item: model, action: {
                            print("Image selected")
                            self.placementSettings.selectedModel = model
                            model.asyncLoadEntity()
                            showBrowse = false
                        })
                        
                    }
                }
                
                .padding(.horizontal, 20.0)
                .padding(.vertical, 10.0)
            }
        }
        
    }
    
    
    
}

struct ItemButton: View {
    let item : Model
    let action : ()->Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(uiImage: item.image)
                .resizable()
                .frame(width: 150.0, height: 150.0)
                .cornerRadius(8.0)
                .aspectRatio(1/1, contentMode: .fit)
                .background(Color(UIColor.secondarySystemFill))
            
        }
        //        .shadow(color: .black.opacity(0.1), radius: 5.0, x: 0.0, y: 0.0)
    }
    
    
}


struct Seperater: View{
    
    var body: some View {
        Divider()
            .padding(.horizontal, 20.0)
            .padding(.vertical, 10.0)
    }
}

