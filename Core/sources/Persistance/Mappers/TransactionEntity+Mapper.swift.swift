//
//  TransactionEntity+Mapper.swift.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import CoreData
import Domain

public extension TransactionEntity {
    func toDomain() -> TransactionCasha {
        TransactionCasha(
            id: self.id,
            name: self.name,
            category: self.category?.name ?? "-",
            amount: self.amount,
            datetime: self.datetime,
            isConfirm: self.isConfirm,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt
        )
    }
    
    func update(from model: TransactionCasha, category: CategoryEntity) {
        self.id = model.id
        self.name = model.name
        self.amount = model.amount
        self.datetime = model.datetime
        self.isConfirm = model.isConfirm
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
        self.category = category
    }
}
