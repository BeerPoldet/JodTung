//
//  Category+CoreDataClass.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/9/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    static let className = String(describing: Category.self)
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        
        if uniqueIdentifier == nil {
            uniqueIdentifier = UUID().uuidString
        }
        print("FUCK")
    }
    
}
