//
//  CoreDataCategoryLocalDataSource.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import Core
import Domain
import CoreData


public final class CoreDataCategoryLocalDataSource: CategoryLocalDataSource {
    private let context: NSManagedObjectContext
    private let manager: CoreDataManager

    public init(manager: CoreDataManager = .shared) {
        self.manager = manager
        self.context = manager.context
    }

    public func save(_ category: CategoryCasha) throws {
        let entity = CategoryEntity(context: context)
        entity.id = category.id
        entity.name = category.name
        entity.isActive = category.isActive
        entity.createdAt = category.createdAt
        entity.updatedAt = category.updatedAt

        try manager.saveContext()
    }

    public func fetchAll() throws -> [CategoryCasha] {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        let results = try context.fetch(request)
        return results.map { $0.toDomain() }
    }

    public func deleteAll() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = CategoryEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try context.execute(deleteRequest)
        try manager.saveContext()
    }

    public func exists(id: String) throws -> Bool {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        return try context.count(for: request) > 0
    }
}
