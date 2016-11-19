//
//  CategoryGroup+CoreDataProperties.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation
import CoreData


extension CategoryGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryGroup> {
        return NSFetchRequest<CategoryGroup>(entityName: "CategoryGroup");
    }

    @NSManaged public var title: String?
    @NSManaged public var persistentType: Int16
    @NSManaged public var uniqueIdentifier: String?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension CategoryGroup {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
