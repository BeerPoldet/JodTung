//
//  CategoryGroup+CoreDataClass.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/9/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation
import CoreData

@objc(CategoryGroup)
public class CategoryGroup: NSManagedObject {
    static let className = String(describing: CategoryGroup.self)
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        if uniqueIdentifier == nil {
            uniqueIdentifier = UUID().uuidString
        }
    }
    
    var type: TransactionType {
        get {
            return TransactionType(persistentValue: persistentType)
        }
        set(newValue) {
            persistentType = newValue.persistentValue
        }
    }
    
    var categoryList: [Category]? {
        return categories?.allObjects as? [Category]
    }
}
