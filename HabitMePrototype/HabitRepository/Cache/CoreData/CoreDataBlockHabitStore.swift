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
    
    
    static func preview() -> CoreDataBlockHabitStore {
        
        let inMemoryURL = URL(fileURLWithPath: "/dev/null")
        return try! CoreDataBlockHabitStore(storeURL: inMemoryURL)
    }
    
    
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
        
        
        // When there are uniquely constrained items, like `id`, update the current unique store with whatever new content is coming in
        // ActivityDetail: Id 1 - favoriteParentName "Dad"
        // Then after some user submits a new entry with the same Id
        // ActivityDetail: Id 1 - favoriteParentName "Mom"
        
        // Will handle this scenario differently for mergePolicy
        // - NSMergeByPropertyObjectTrumpMergePolicy: "Mom" will be the winner (the in-memory property)
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
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

