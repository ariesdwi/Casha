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
        // Try to locate the Core Data model in the correct bundle
        let possibleBundles = [
            Bundle.main,
            Bundle(for: CoreDataStack.self)
        ]
        
        var model: NSManagedObjectModel?
        
        for bundle in possibleBundles {
            if let url = bundle.url(forResource: "CashaModel", withExtension: "momd"),
               let loadedModel = NSManagedObjectModel(contentsOf: url) {
                model = loadedModel
                break
            }
        }
        
        guard let finalModel = model else {
            fatalError("❌ Failed to locate or load Core Data model from any bundle")
        }

        // Initialize the container with the loaded model
        persistentContainer = NSPersistentContainer(name: "CashaModel", managedObjectModel: finalModel)

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                // Optionally: delete store and retry once if desired
                fatalError("❌ Failed to load Core Data stack: \(error)")
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
