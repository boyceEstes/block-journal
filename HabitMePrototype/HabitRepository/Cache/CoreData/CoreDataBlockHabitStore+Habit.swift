//
//  CoreDataBlockHabitStore+Habit.swift
//  HabitMePrototype
//
//  Created by Boyce Estes on 3/25/24.
//

import Foundation
import CoreData



extension NSManagedObjectContext {
    
    func fetchHabit(withID habitID: String) throws -> ManagedHabit {
        
        guard let managedHabit = try fetch(ManagedHabit.findHabitRequest(with: habitID)).first else {
            throw HabitRepositoryError.couldNotFindHabitWithID(id: habitID)
        }
        
        return managedHabit
    }
}


extension CoreDataBlockHabitStore {
    
    
    func create(_ habit: Habit) async throws {
        
        let context = context
        try await context.perform {
            
            let managedHabit = ManagedHabit(context: context)
            managedHabit.id = habit.id
            managedHabit.name = habit.name
            managedHabit.color = habit.color
            managedHabit.habitRecords = nil
            managedHabit.activityDetails = try habit.activityDetails.toManaged(context: context)
            
            // save
            try context.save()
            // FIXME: Rollback if there is an error
        }
    }
    
    
    func update(habitID: String, with habit: Habit) async throws {
        
        let context = context
        
        try await context.perform {
            
            let managedHabit = try context.fetchHabit(withID: habitID)
            managedHabit.name = habit.name
            managedHabit.color = habit.color
            managedHabit.activityDetails = try habit.activityDetails.toManaged(context: context)
            
            try context.save()
            // FIXME: Rollback if there is an error
        }
    }
    
    
    func destroy(_ habit: Habit) async throws {
        
        let context = context
        try await context.perform {
            let managedHabit = try habit.toManaged(context: context)
            context.delete(managedHabit)
            
            // save
            try context.save()
            // FIXME: Rollback if there is an error
        }
    }
}
