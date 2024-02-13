//
//  CreateActivityDetailView.swift
//  HabitMePrototype
//
//  Created by Boyce Estes on 2/11/24.
//

import SwiftUI

enum ActivityDetailCalculationType: String, CaseIterable, Identifiable {
     
    case sum = "Sum"
    case average = "Average"
    
    var id: ActivityDetailCalculationType { self }
   
    var explanation: String {
        
        var _explanation: String = .calculationTypExplanation
        
//        switch self {
//        case .sum:
//            _explanation.append(" \(String.sumExplanation)")
//        case .average:
//            _explanation.append(" \(String.avgExplanation)")
//        }
        
        return _explanation
    }
}


struct CreateActivityDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var detailName: String = ""
    @State private var typeSelection: ActivityDetailType = .text
    @State private var units: String = ""
    @State private var calculationTypeSelection: ActivityDetailCalculationType = .sum
    
    var body: some View {
        VStack(spacing: .vSectionSpacing) {
            HStack {
                
                TextField("Name", text: $detailName)
                    .textFieldBackground(color: .tertiaryBackground)
                
                Picker("Type", selection: $typeSelection) {
                    ForEach(ActivityDetailType.allCases) { type in
                        Text("\(type.rawValue)")
                    }
                }
                .tint(.primary)
                .sectionBackground(padding: 0, color: .tertiaryBackground)
            }
            .sectionBackground()
            
            switch typeSelection {
            case .number:
                numberDetailSection
                
            case .text:
                Text("Example 'There was a knock at the door that interrupted my flow. I was so close to finishing the equation of life, but I've lost my train of thought and I can't find it again.'")
                    .font(.footnote)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .animation(.default, value: typeSelection)
        .sheetyTopBarNav(title: "Create Activity Detail", dismissAction: { dismiss() })
    }
    
    
    var numberDetailSection: some View {
        
        VStack(alignment: .leading, spacing: .vItemSpacing) {
            
            Text("Number Details")
                .font(.sectionTitle)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: .vSectionSpacing) {
                HStack {
                    TextField("Units", text: $units)
                        .frame(width: 85)
                        .textFieldBackground(color: .tertiaryBackground)
                    Spacer()
                    Text("Example '27\(units.isEmpty ? "" : " \(units)")'")
                }
                .sectionBackground()
                
                calculationType
                .sectionBackground()
            }
            
            Text("\(calculationTypeSelection.explanation)")
                .font(.footnote)
                .padding(.horizontal)
        }
    }
    
    
    var calculationType: some View {
        HStack {
            Text("Calculation Type")
            Spacer()
            Picker("Calculation Type", selection: $calculationTypeSelection) {
                ForEach(ActivityDetailCalculationType.allCases) { type in
                    Text("\(type.rawValue)")
                }
            }
            .tint(.primary)
            .sectionBackground(padding: 0, color: .tertiaryBackground)
        }
    }
}

#Preview {
    
    NavigationStack {
        CreateActivityDetailView()
            .background(Color.primaryBackground)
    }
}
