//
//  Transaction+CoreDataProperties.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction");
    }

    @NSManaged public var creationNSDate: NSDate?
    @NSManaged public var note: String?
    @NSManaged public var uniqueIdentifier: String?
    @NSManaged public var value: Double
    @NSManaged public var category: Category?

}
