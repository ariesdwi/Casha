//
//  TransactionEntity.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 18/07/25.
//

import Foundation
import CoreData

@objc(TransactionEntity)
public class TransactionEntity: NSManagedObject {}

extension TransactionEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var amount: Double
    @NSManaged public var datetime: Date
    @NSManaged public var isConfirm: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var category: CategoryEntity?  // Relationship
}
