//
//  ControlView.swift
//  ARTracking
//
//  Created by Monyneath Mol on 30/12/21.
//
//
import SwiftUI

struct ControlView: View {
    @Binding var isControlVisible : Bool
    @Binding var showBrowse : Bool
    var body: some View {
        VStack{
            
            ControlVisibilityToggleButton(isControlVisible: $isControlVisible)
            Spacer()
            
            if isControlVisible {
                ControlButtonBar(showBrowse: $showBrowse)
            }
            
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12")
    }
}


struct ControlVisibilityToggleButton: View {
    
    @Binding var isControlVisible : Bool
    
    var body: some View {
        HStack{
            Spacer()
        
                ZStack{
                    Color.black.opacity(0.2)
                    Button {
                        print("Control Visibility pressed")
                        
                        isControlVisible.toggle()
                    } label: {
                        Image(systemName: isControlVisible ? "rectangle" : "slider.horizontal.below.rectangle")
                            .font(.system(size: 25.0))
                            .foregroundColor(.white)
                    }

                }
                .frame(width: 50, height: 50)
                .cornerRadius(8)
                .padding(16.0)
            
           
        }
    }
}


struct ControlButtonBar: View {
    
    @Binding var showBrowse : Bool
    
    var body: some View {
        HStack{
            
            
            ControlButton(systemItemName: "clock.fill", action: {
                print("clock selected")
            })
            
            Spacer()
            
            ControlButton(systemItemName: "square.grid.2x2", action: {
                print("square selected")
                showBrowse.toggle()
            }).sheet(isPresented: $showBrowse, onDismiss: nil) {
                BrowseView(showBrowse: $showBrowse)
            }
             
            Spacer()
            
            ControlButton(systemItemName: "slider.horizontal.3", action: {
                print("Horizontal Selected")
            })
        }
        
        .frame(maxWidth:500.0)
        .padding(16.0)
        .background(Color.black.opacity(0.2))
    }
}

struct ControlButton: View{
    
    var systemItemName: String
    var action : ()->Void

    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemItemName)
        }
        .font(.system(size: 35.0))
        .foregroundColor(Color.white)
        .buttonStyle(.plain)
        .frame(width: 50, height: 50)
    }
}



