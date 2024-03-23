//
//  HabitRecordsForDateFRCDataSourceAdapter.swift
//  HabitMePrototype
//
//  Created by Boyce Estes on 3/12/24.
//

import Foundation
import Combine
import CoreData


public protocol HabitRecordsForDateDataSource {
    
    var habitRecordsForDate: AnyPublisher<[Date: [ManagedHabitRecord]], Never> { get }
}


public class ManagedHabitRecordsForDateFRCDataSourceAdapter: NSObject, HabitRecordsForDateDataSource {
    
    private let frc: NSFetchedResultsController<ManagedHabitRecord>
    public var habitRecordsForDateSubject = CurrentValueSubject<[Date: [ManagedHabitRecord]], Never>([:])
    public var habitRecordsForDate: AnyPublisher<[Date: [ManagedHabitRecord]], Never>
//    public var routinesSubject = CurrentValueSubject<[Routine], Error>([])
//    public var routines: AnyPublisher<[Routine], Error>
    
    
    public init(frc: NSFetchedResultsController<ManagedHabitRecord>) {
        
        self.frc = frc
        self.habitRecordsForDate = habitRecordsForDateSubject.eraseToAnyPublisher()
        
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
            updateWithLatestValues()
//            routines.value = managedRoutines.toModel()
        } catch {
            let nsError = error as NSError
            fatalError("Unresoled error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    private func updateWithLatestValues() {
        
        let managedHabitRecords = frc.fetchedObjects ?? []
        
        print("Update with latest value count: '\(managedHabitRecords.count)'")
        
        let formatedRecordsWithDate = datesWithHabitRecords(for: managedHabitRecords)
        
        habitRecordsForDateSubject.send(formatedRecordsWithDate)
//        routinesSubject.send(managedRoutines.toModel())
    }
    
    
    private func datesWithHabitRecords(for habitRecords: [ManagedHabitRecord]) -> [Date: [ManagedHabitRecord]] {
        
        var _datesWithHabitRecords = [Date: [ManagedHabitRecord]]()
        
        print("update habit records by loading them")
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        calendar.locale = .current
        
        guard let startOf2024 = DateComponents(calendar: calendar, year: 2024, month: 1, day: 1).date?.noon,
              let today = Date().noon,
              let days = calendar.dateComponents([.day], from: startOf2024, to: today).day
        else { return [:] }
        
        
        print("received from habitRepository fetch... \(habitRecords.count)")
        //
        // Convert to a dictionary in order for us to an easier time in searching for dates
        var dateActivityRecordDict = [Date: [ManagedHabitRecord]]()
        
        for record in habitRecords {
            
            guard let noonDate = record.completionDate?.noon else { return [:] }
            
            if dateActivityRecordDict[noonDate] != nil {
                dateActivityRecordDict[noonDate]?.append(record)
            } else {
                dateActivityRecordDict[noonDate] = [record]
            }
        }
        
        
        // Maybe for now, lets just start at january 1, 2024 for the beginning.
        for day in 0...days {
            // We want to get noon so that everything is definitely the exact same date (and we inserted the record dictinoary keys by noon)
            guard let noonDate = calendar.date(byAdding: .day, value: day, to: startOf2024)?.noon else { return [:] }
            
            
            if let habitRecordsForDate = dateActivityRecordDict[noonDate] {
                _datesWithHabitRecords[noonDate] = habitRecordsForDate
            } else {
                _datesWithHabitRecords[noonDate] = []
            }
        }
        
        return _datesWithHabitRecords
    }
}


extension ManagedHabitRecordsForDateFRCDataSourceAdapter: NSFetchedResultsControllerDelegate {
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        print("BOYCE: Did change routine core data content")
        
        updateWithLatestValues()
    }
}