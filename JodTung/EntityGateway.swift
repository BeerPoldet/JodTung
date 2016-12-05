//
//  EntityGateway.swift
//  JodTung
//
//  Created by Dev on 12/5/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation

protocol EntityGateway {
    func save()
    
    func categoryGroupsCount() -> Int?
    
    func categoryGroups() -> [CategoryGroup]?
    
    func makeCategoryGroup() -> CategoryGroup
    
    func categoryGroupBy(uniqueIdentifier: String) -> CategoryGroup?
    
    func categories() -> [Category]?
    
    func categories(ofGroup categoryGroup: CategoryGroup) -> [Category]?
    
    func makeCategory() -> Category
    
    func categoryBy(uniqueIdentifier: String) -> Category?
    
    func transactions(ofDate date: Date) -> [Transaction]?
    
    func transactionCount(ofDate date: Date) -> Int?
    
    func makeTransaction() -> Transaction
    
    func delete(transaction: Transaction)
}
