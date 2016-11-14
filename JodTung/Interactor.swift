//
//  TransactionInteractor.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/9/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation

public class Interactor: Boundary {
    var gateway: EntityGateway?
    
    // MARK: - Category
    
    func categories() -> [CategoryInfo]? {
        return gateway?.categories()?.map { CategoryInfo(category: $0) }
    }
    
    func createCategory(categoryInfo: CategoryInfo) {
        let category = gateway?.makeCategory()
        category?.title = categoryInfo.title
        category?.iconName = categoryInfo.iconName
    }
    
    // MARK: - Transaction
    
    func transactions(forDate date: Date) -> [Transaction]? {
        return gateway?.transactions(forDate: date)
    }
    
    func createTransaction(info transactionInfo: TransactionInfo, categoryInfo: CategoryInfo) {
        guard let categoryUniqueIdentifier = categoryInfo.uniqueIdentifier else {
            fatalError("categoryUniqueIdentifier cannot be nil")
        }
        let transaction = gateway?.makeTransaction()
        let category = gateway?.categoryBy(uniqueIdentifier: categoryUniqueIdentifier)
        transaction?.category = category
        transaction?.creationDate = transactionInfo.creationDate as NSDate
        transaction?.note = transactionInfo.note
        transaction?.value = transactionInfo.value
    }
    
    func delete(transaction: Transaction) {
        gateway?.delete(transaction: transaction)
    }
    
    func save() {
        gateway?.save()
    }
}

protocol Boundary {
    
    func categories() -> [CategoryInfo]?
    
    func createCategory(categoryInfo: CategoryInfo)
    
    func transactions(forDate date: Date) -> [Transaction]?
    
    func createTransaction(info transactionInfo: TransactionInfo, categoryInfo: CategoryInfo)
    
    func delete(transaction: Transaction)
    
    func save()
}


protocol EntityGateway {
    
    func categories() -> [Category]?
    
    func categoryBy(uniqueIdentifier : String) -> Category?
    
    func makeCategory() -> Category
    
    func transactions(forDate date: Date) -> [Transaction]?
    
    func makeTransaction() -> Transaction
    
    func delete(transaction: Transaction)
    
    func save()
}
