//
//  CoreDataSourceTests.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/18/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import XCTest
@testable import JodTung

class DataStorageTests: XCTestCase {
    
    let dataStorage = DataStorage(storageType: .inMemory)
    
    override func setUp() {
        super.setUp()
        
        let incomeCategoryGroup = dataStorage.makeCategoryGroup()
        incomeCategoryGroup.title = "income"
        
        let foodCategoryGroup = dataStorage.makeCategoryGroup()
        foodCategoryGroup.title = "food"
        
        let salaryCategory = dataStorage.makeCategory()
        salaryCategory.title = "salary"
        salaryCategory.group = incomeCategoryGroup
        salaryCategory.iconName = Icon.salary.name
        
        let breakfastCategory = dataStorage.makeCategory()
        breakfastCategory.title = "breakfast"
        breakfastCategory.group = foodCategoryGroup
        breakfastCategory.iconName = Icon.breakfast.name
        
        let dinnerCategory = dataStorage.makeCategory()
        dinnerCategory.title = "dinner"
        dinnerCategory.group = foodCategoryGroup
        dinnerCategory.iconName = Icon.dinner.name
        
        dataStorage.save()
    }
    
    func testCanListCategoriesByGroup_containCorrectData() {
        
        let savedCategoryGroups = dataStorage.categoryGroups()
        let savedFoodCategories = savedCategoryGroups?.first { $0.title == "food" }?.categoryList
        
        XCTAssertTrue(savedCategoryGroups?.count == 2)
        XCTAssertTrue(savedFoodCategories?.contains { $0.title == "breakfast" } == true)
        
        let dinnerCategory = savedFoodCategories?.first { $0.title == "dinner" }
        XCTAssertTrue(dinnerCategory?.iconName == Icon.dinner.name)
    }
    
    func testCanListCategoryGroups_inCorrectDefaultSortingOrder() {
        let categoryGroups = dataStorage.categoryGroups()
        XCTAssertTrue(categoryGroups?.first?.title == "food")
        XCTAssertTrue(categoryGroups?.last?.title == "income")
    }
    
    func testCanListCategories_inCorrectDefaultSortingOrder() {
        let categories = dataStorage.categories()
        XCTAssertTrue(categories?.first?.title == "breakfast")
        XCTAssertTrue(categories?.last?.title == "salary")
    }
    
}
