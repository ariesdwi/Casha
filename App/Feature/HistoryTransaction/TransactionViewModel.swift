//
//  TransactionViewModel.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import Foundation
import Domain

final class TransactionViewModel: ObservableObject {
    @Published var transactions: [TransactionCasha] = []
}
