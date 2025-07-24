//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import Domain
import CoreData

public protocol CategoryLocalDataSource {
    func save(_ category: CategoryCasha) throws
    func fetchAll() throws -> [CategoryCasha]
    func deleteAll() throws
    func exists(id: String) throws -> Bool
}
