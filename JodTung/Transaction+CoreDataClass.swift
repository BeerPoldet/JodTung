//
//  Transaction+CoreDataClass.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/9/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {
    static let className = String(describing: Transaction.self)
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        if uniqueIdentifier == nil {
            uniqueIdentifier = UUID().uuidString
        }
    }
    
    var creationDate: Date? {
        get {
            return creationNSDate as? Date
        }
        set(newValue) {
            creationNSDate = newValue as NSDate?
            
        }
    }
}
