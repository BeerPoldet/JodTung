//
//  Accountant.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/17/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation

class Accountant {
    let entityGateway: EntityGateway
    let accountBootstrapFactory: AccountBootstrapFactory
    
    init(entityGateway: EntityGateway, accountBootstrapFactory: AccountBootstrapFactory) {
        self.entityGateway = entityGateway
        self.accountBootstrapFactory = accountBootstrapFactory
        
        if entityGateway.categoryGroupsCount() == 0 {
            accountBootstrapFactory.boostrap()
        }
    }
    
    // MARK: - Data Accesss
    
    var categoryGroups: [CategoryGroup]? {
        return entityGateway.categoryGroups()
    }
    
    var categories: [Category]? {
        return entityGateway.categories()
    }
    
    func categories(ofGroup categoryGroup: CategoryGroup) -> [Category]? {
        return entityGateway.categories(ofGroup: categoryGroup)
    }
    
    func transactions(ofDate date: Date) -> [Transaction]? {
        return entityGateway.transactions(ofDate: date)
    }
    
    func transactionCount(ofDate date: Date) -> Int? {
        return entityGateway.transactionCount(ofDate: date)
    }
    
    func add(transactionInfo: TransactionInfo) {
        let transaction = entityGateway.makeTransaction()
        transaction.creationDate = transactionInfo.creationDate
        transaction.note = transactionInfo.note
        transaction.value = transactionInfo.value
        transaction.category = transactionInfo.category
        entityGateway.save()
    }
}

struct TransactionInfo {
    var creationDate: Date
    var note: String
    var value: Double
    var category: Category
}
