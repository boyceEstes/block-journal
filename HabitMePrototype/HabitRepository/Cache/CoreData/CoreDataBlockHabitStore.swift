//
//  CoreDataBlockHabitsStore.swift
//  HabitMePrototype
//
//  Created by Boyce Estes on 3/10/24.
//

import CoreData


// NOTE: If we ever want to swap this out for another way to get data (like a remote server, create a protocol, HabitBlocksStore
public class CoreDataBlockHabitStore {
    
    private let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        
        container = try NSPersistentContainer.load(name: "BlockHabit", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
        
        printCoreDataStoreURLLocation()
        
        // TODO: SEED INFORMATION HERE FOR NEW INSTALLS
    }
    
    
    private func printCoreDataStoreURLLocation() {
        
        guard let sqliteURL = container.persistentStoreCoordinator.persistentStores.first?.url else { return }
        
        print("--> Core Data database location: \(sqliteURL.absoluteString)")
    }
}
    

private extension NSPersistentContainer {
    
    enum LoadingError: Error {
        case modelNotFound
        case failedToLoadPersistentStores(Error)
    }
    
    
    static func load(name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        
        let description = NSPersistentStoreDescription(url: url)
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        container.persistentStoreDescriptions = [description]
        
        var loadingError: Error?
        container.loadPersistentStores { loadingError = $1 }
        try loadingError.map { throw LoadingError.failedToLoadPersistentStores($0) }
        
        return container
    }
}


private extension NSManagedObjectModel {
    
    // Necessary for in-memory caching so that we can avoid ambiguous NSEntityDescription warning during testing
    private static var _model: NSManagedObjectModel?
    
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        
        if _model == nil {
            _model = bundle
               .url(forResource: name, withExtension: "momd")
               .flatMap { url in
                   NSManagedObjectModel(contentsOf: url)
               }
        }
        
        return _model
    }
}

