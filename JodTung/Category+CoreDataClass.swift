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
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        if uniqueIdentifier == nil {
            uniqueIdentifier = UUID().uuidString
        }
    }
}
