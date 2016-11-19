//
//  TransactionType.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/14/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation

enum TransactionType: Int {
    case expense = 0, income
    
    var title: String {
        switch self {
        case .expense:
            return "Expense"
        case .income:
            return "Income"
        }
    }
    
    var modifier: Int {
        switch self {
        case .expense:
            return -1
        case .income:
            return 1
        }
    }
}

extension TransactionType {
    init(persistentValue: Int16) {
        self = TransactionType(rawValue: Int(persistentValue))!
    }
    
    var persistentValue: Int16 {
        return Int16(rawValue)
    }
}
