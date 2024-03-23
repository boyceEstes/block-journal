//
//  HabitFRCDataSourceAdapter.swift
//  HabitMePrototype
//
//  Created by Boyce Estes on 3/12/24.
//

import Foundation
import Combine
import CoreData


public protocol HabitDataSource {
    
    var habits: AnyPublisher<[Habit], Never> { get }
}


public class ManagedHabitFRCDataSourceAdapter: NSObject, HabitDataSource {
    
    private let frc: NSFetchedResultsController<ManagedHabit>
    public var habitsSubject = CurrentValueSubject<[Habit], Never>([])
    public var habits: AnyPublisher<[Habit], Never>
//    public var routinesSubject = CurrentValueSubject<[Routine], Error>([])
//    public var routines: AnyPublisher<[Routine], Error>
    
    
    public init(frc: NSFetchedResultsController<ManagedHabit>) {
        
        self.frc = frc
        self.habits = habitsSubject.eraseToAnyPublisher()
        
        super.init()
        
        setupFRC()
    }
    
    
    private func setupFRC() {
        
        frc.delegate = self
        
        performFetch()
    }
    
    
    private func performFetch() {
        
        do {
            try frc.performFetch()
            try updateWithLatestValues()
//            routines.value = managedRoutines.toModel()
        } catch {
            let nsError = error as NSError
            fatalError("Unresoled error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    private func updateWithLatestValues() throws {
        
        let managedHabits = frc.fetchedObjects ?? []
        
        print("Update with latest value count: '\(managedHabits.count)'")
        
        let habits = try managedHabits.toModel()
        
        habitsSubject.send(habits)
//        routinesSubject.send(managedRoutines.toModel())
    }
}


extension ManagedHabitFRCDataSourceAdapter: NSFetchedResultsControllerDelegate {
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        print("BOYCE: Did change routine core data content")
        
        try? updateWithLatestValues()
    }
}
