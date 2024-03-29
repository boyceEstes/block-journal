//
//  ContentView.swift
//  HabitMePrototype
//
//  Created by Boyce Estes on 1/20/24.
//

import SwiftUI


enum SpecialHabitError: Error {
    
}

extension Date {
    var noon: Date? {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)
    }
    
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}


struct ContentView: View {
    
    // Home navigation
    @State var homeNavigationFlowPath = [HomeNavigationFlow.StackIdentifier]()
    @State var homeNavigationFlowDisplayedSheet: HomeNavigationFlow.SheetyIdentifier?
    
    // Habit Detail navigation
    @State var habitDetailNavigationFlowDisplayedSheet: HabitDetailNavigationFlow.SheetyIdentifier?
    
    // Create Habit navigation
    @State var createEditHabitNavigationFlowPath = [CreateEditHabitNavigationFlow.StackIdentifier]()
    
    // Add Details navigation
    @State var addDetailsNavigationFlowDisplayedSheet: AddDetailsNavigationFlow.SheetyIdentifier?
    
    var body: some View {
        let _ = print("Hello world home view")
        makeHomeViewWithSheetyStackNavigation()
    }
}


class AppState {
    
    static let shared = AppState()
    
    private init() {}
    
    private(set) var selectedDate = Date().noon!
    
    func setSelectedDateToNext() {
        
        print("Go forward in time unless its today")
    }
    
    func setSelectedDateToPrevious() {
        
        print("Go back in time")
        
    }
}




#Preview {
    ContentView()
}
