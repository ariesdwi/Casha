//
//  CategoryEntity+Mapper.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import CoreData
import Domain

public extension CategoryEntity {
    func toDomain() -> CategoryCasha {
        CategoryCasha(
            id: self.id,
            name: self.name,
            isActive: self.isActive,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt
        )
    }
    
    func update(from model: CategoryCasha) {
        self.id = model.id
        self.name = model.name
        self.isActive = model.isActive
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
    }
}
