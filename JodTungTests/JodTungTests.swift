//
//  JodTungTests.swift
//  JodTungTests
//
//  Created by Poldet Assanangkornchai on 10/16/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import XCTest
import CoreData
@testable import JodTung

class JodTungTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let inMemPersistent = InMemoryPersistent()
        let todayTxn = inMemPersistent.makeTransaction()
        todayTxn.creationDate = Date() as NSDate
        
        let beforeTodayTxn = inMemPersistent.makeTransaction()
        beforeTodayTxn.creationDate = NSDate().addingTimeInterval(-4*60*60)
        
        let yesterdayTxn = inMemPersistent.makeTransaction()
        yesterdayTxn.creationDate = NSDate().addingTimeInterval(-24*60*60)
        
        let tomorrowTxn = inMemPersistent.makeTransaction()
        tomorrowTxn.creationDate = NSDate().addingTimeInterval(24*60*60)
        
        let todayTransactions = inMemPersistent.transactions(forDate: Date())!
        print(todayTransactions)
        XCTAssert(todayTransactions.count == 2)
        
        XCTAssert(todayTransactions.first == todayTxn)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
