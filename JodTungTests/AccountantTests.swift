//
//  AccountantTest.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/17/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import XCTest
@testable import JodTung

class AccountantTests: XCTestCase {
    var accountant: Accountant!
    var dataStorage: DataStorage!
    
    override func setUp() {
        super.setUp()
        
        dataStorage = DataStorage(storageType: .inMemory)
        let accountBootstrapFactory = AccountBootstrapFactory(dataStorage: dataStorage)
        accountant = Accountant(entityGateway: dataStorage, accountBootstrapFactory: accountBootstrapFactory)
    }
    
    func testCanListBootstrapedCategory_isNotEmpty() {
        XCTAssertTrue(accountant.categories?.count != 0)
    }
    
    func testAddTransaction_queryWillFound() {
        let someCategory = accountant.categories!.first!
        
        let transactionInfo = TransactionInfo(
            creationDate: Date(),
            note: "Subway",
            value: 60,
            category: someCategory
        )
        accountant.add(transactionInfo: transactionInfo)
        
        let savedTransaction = accountant.transactions(ofDate: Date())?.first
        XCTAssertNotNil(savedTransaction)
        XCTAssertTrue(savedTransaction?.note == transactionInfo.note)
    }
    
    func testAddTransactionCreatedYesterday_queryWillNotFoundForToday() {
        let someCategory = accountant.categories!.first!
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let transactionInfo = TransactionInfo(
            creationDate: yesterday,
            note: "Subway",
            value: 60,
            category: someCategory
        )
        accountant.add(transactionInfo: transactionInfo)
        
        let savedTransaction = accountant.transactions(ofDate: Date())?.first
        XCTAssertNil(savedTransaction)
    }
    
    func testAddTransactionCreatedTomorrow_queryWillNotFoundForToday() {
        let someCategory = accountant.categories!.first!
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let transactionInfo = TransactionInfo(
            creationDate: tomorrow,
            note: "Subway",
            value: 60,
            category: someCategory
        )
        accountant.add(transactionInfo: transactionInfo)
        
        let savedTransaction = accountant.transactions(ofDate: Date())?.first
        XCTAssertNil(savedTransaction)
    }
    
    func testCanListBootstrapedCategoryGroup_isNotEmpty() {
        XCTAssertTrue(accountant.categoryGroups?.isEmpty == false)
    }
    
    func testCategoryFromCategoryGroup_canListCorrectly() {
        let categoryGroup = accountant.categoryGroups!.first!
        let category = categoryGroup.categoryList!.first!
        XCTAssertNotNil(category.title)
    }
    
    func testCanListCategoriesByGroup_containCorrectData() {
        let foodCategoryGroup = dataStorage.makeCategoryGroup()
        foodCategoryGroup.title = "food"
        
        let incomeCategoryGroup = dataStorage.makeCategoryGroup()
        incomeCategoryGroup.title = "income"
        
        let breakfastCategory = dataStorage.makeCategory()
        breakfastCategory.title = "breakfast"
        breakfastCategory.group = foodCategoryGroup
        
        let dinnerCategory = dataStorage.makeCategory()
        dinnerCategory.title = "dinner"
        dinnerCategory.group = foodCategoryGroup
        
        let salaryCategory = dataStorage.makeCategory()
        salaryCategory.title = "salary"
        salaryCategory.group = incomeCategoryGroup
        
        dataStorage.save()
        
//        let listedCategories = accountant.categories(ofGroup: foodCategoryGroup)
        let listedCategories = foodCategoryGroup.categoryList
        XCTAssertTrue(listedCategories?.count == 2)
        XCTAssertTrue(listedCategories?.contains { $0.title == breakfastCategory.title } == true)
    }
}
