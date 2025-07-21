//
//  CoreDataStack.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 18/07/25.
//

import Foundation
import CoreData
import Domain

public class CoreDataStack {
    public static let shared = CoreDataStack()

    public let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "CashaModel") // match your .xcdatamodeld filename
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("❌ Failed to load Core Data store: \(error)")
            }
        }
    }

    public var context: NSManagedObjectContext {
        container.viewContext
    }

    public func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Failed to save context: \(error)")
            }
        }
    }

}
