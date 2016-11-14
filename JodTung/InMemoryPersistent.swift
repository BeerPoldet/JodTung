//
//  InMemoryPersistant.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/9/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import Foundation
import CoreData

class InMemoryPersistent {
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        if let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles) {
            let persistentCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            
            do {
                try persistentCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            } catch {
                print(error)
            }
            
            managedObjectContext.persistentStoreCoordinator = persistentCoordinator
        }
        
        return managedObjectContext
    }()
    
    func makeTransaction() -> Transaction {
        return Transaction(context: managedObjectContext)
    }
    
    func transactions(forDate date: Date) -> [Transaction]? {
        var transactions: [Transaction]?
        managedObjectContext.performAndWait {
            let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            request.predicate = NSPredicate(format: "creationDate = %@", date as NSDate)
            do {
                transactions = try request.execute()
            } catch {
                print(error)
            }
        }
        
        return transactions
    }
    
    func delete(transaction: Transaction) {
        
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}
