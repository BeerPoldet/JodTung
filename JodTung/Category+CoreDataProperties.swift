//
//  Category+CoreDataProperties.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/11/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var iconName: String?
    @NSManaged public var title: String?
    @NSManaged public var uniqueIdentifier: String?
    @NSManaged public var group: CategoryGroup?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension Category {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
