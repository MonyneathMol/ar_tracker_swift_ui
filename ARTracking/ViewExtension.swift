//
//  ViewExtension.swift
//  ARTracking
//
//  Created by Monyneath Mol on 8/1/22.
//

import SwiftUI

extension View{
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View{
        switch shouldHide {
        case true: self.hidden()
        case false: self            
        }
    }
}
