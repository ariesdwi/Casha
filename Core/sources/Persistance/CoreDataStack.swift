//
//  CoreDataStack.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 18/07/25.
//

import Foundation
import CoreData
import Domain

public final class CoreDataStack {
    public static let shared = CoreDataStack()
    
    public let persistentContainer: NSPersistentContainer
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        // 1. Initialize container with explicit model loading
        let bundle = Bundle(for: CoreDataStack.self)
        guard let modelURL = bundle.url(forResource: "CashaModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to locate or load Core Data model")
        }
        
        persistentContainer = NSPersistentContainer(name: "CashaModel", managedObjectModel: model)
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    public func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
