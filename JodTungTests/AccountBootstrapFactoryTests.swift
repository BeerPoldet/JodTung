//
//  CategoryGroupBootstrapFactoryTests.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/18/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import XCTest
@testable import JodTung

class AccountBootstrapFactoryTests: XCTestCase {
    
    var dataStorage: DataStorage!
    var iconFactory = JTIconImageFactory()
    var accountBootstrapFactory: AccountBootstrapFactory!
    
    override func setUp() {
        super.setUp()
        
        dataStorage = DataStorage(storageType: .inMemory)
        accountBootstrapFactory = AccountBootstrapFactory(dataStorage: dataStorage)
    }
    
    func testBoostraped_dataStorageWillContainCorrectDatas() {
        
        XCTAssertTrue(dataStorage.categoryGroupsCount() == 0, "Category Group will be empty at first time")
        
        accountBootstrapFactory.boostrap()
        
        let bootstarpedCategoryGroups = dataStorage.categoryGroups()
        XCTAssertNotNil(bootstarpedCategoryGroups)
        XCTAssertTrue(bootstarpedCategoryGroups!.count == accountBootstrapFactory.bootstrapDatas.count)
        
        let someBootstrapGroupData = accountBootstrapFactory.bootstrapDatas.random
        let bootstrapedGroupData = bootstarpedCategoryGroups!.first { $0.title == someBootstrapGroupData.title }
        XCTAssertTrue(bootstrapedGroupData?.type == someBootstrapGroupData.type, "Contain correct category group")
        
        XCTAssertTrue(bootstrapedGroupData?.categories?.count == someBootstrapGroupData.categories.count, "Contain equals category count")
        
        let someBootstrapCategoryData = someBootstrapGroupData.categories.random
        let bootstrapedCategoryData = bootstrapedGroupData?.categoryList?.first { $0.title == someBootstrapCategoryData.title }
        XCTAssertNotNil(bootstrapedCategoryData, "Inside group will contain the same cateory that bootstrap has")
        XCTAssertTrue(bootstrapedCategoryData?.iconName == someBootstrapCategoryData.icon.name)
        let icon = Icon(rawValue: (bootstrapedCategoryData!.iconName)!)
        XCTAssertTrue(icon?.image(usingFactory: iconFactory) == someBootstrapCategoryData.icon.image(usingFactory: iconFactory))
    }
    
}
