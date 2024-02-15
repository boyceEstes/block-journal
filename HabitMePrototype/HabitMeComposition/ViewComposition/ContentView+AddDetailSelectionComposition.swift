//
//  ContentView+AddDetailSelectionView.swift
//  HabitMePrototype
//
//  Created by Boyce Estes on 1/31/24.
//

import SwiftUI


class AddDetailsNavigationFlow: NewSheetyNavigationFlow {
    
    // MARK: Properties
    @Published var displayedSheet: SheetyIdentifier?
    
    // MARK: Sheety Identifier
    enum SheetyIdentifier: Identifiable, Hashable {
        
        var id: Int { self.hashValue }
        
        case createActivityDetail
    }
}


extension ContentView {
    
    
    @ViewBuilder
    func makeAddDetailsViewWithSheetyNavigation(selectedDetails: Binding<[DataActivityDetail]>, selectedColor: Color?) -> some View {
        
        makeAddDetailsView(selectedDetails: selectedDetails, selectedColor: selectedColor)
            .sheet(item: $addDetailsNavigationFlowDisplayedSheet) { identifier in
                switch identifier {
                case .createActivityDetail:
                    makeCreateActivityDetailView()
                }
            }
    }
    
    
    @ViewBuilder
    func makeAddDetailsView(selectedDetails: Binding<[DataActivityDetail]>, selectedColor: Color?) -> some View {
        
        AddDetailsView(
            selectedDetails: selectedDetails,
            detailSelectionColor: selectedColor,
            goToCreateActivityDetail: goToCreateActivityDetailFromAddDetailSelection
        )
    }
    
    
    private func goToCreateActivityDetailFromAddDetailSelection() {
        
        addDetailsNavigationFlowDisplayedSheet = .createActivityDetail
    }
}


