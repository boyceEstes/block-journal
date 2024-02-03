//
//  ContentView+AddDetailSelectionView.swift
//  HabitMePrototype
//
//  Created by Boyce Estes on 1/31/24.
//

import SwiftUI


extension ContentView {
    
    @ViewBuilder
    func makeAddDetailSelectionView(selectedDetails: Binding<[DataActivityDetail]>) -> some View {
        
        AddDetailsSelectionView(selectedDetails: selectedDetails)
    }
}

