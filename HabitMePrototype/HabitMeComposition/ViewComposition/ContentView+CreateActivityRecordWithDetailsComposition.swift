//
//  ContentView+CreateActivityRecordWithDetailsComposition.swift
//  HabitMePrototype
//
//  Created by Boyce Estes on 2/4/24.
//

import SwiftUI



extension ContentView {
    
    @ViewBuilder
    func makeCreateActivityRecordWithDetails(activity: DataHabit, selectedDay: Date) -> some View {
        
        let activityDetailCount = activity.activityDetails.count
        NavigationStack {
            CreateHabitRecordWithDetailsView(activity: activity, selectedDay: selectedDay)
        }
        // Basic dynamic sizing - not the fun stuff I'm experimenting with but simple and safe
        .recordSheetPresentation(activityDetailCount: activityDetailCount)
    }
}

