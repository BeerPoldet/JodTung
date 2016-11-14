//
//  SQLiteMemoryPersistent.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/11/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import CoreData
import Ensembles

class SQLiteMemoryPersistent: NSObject, EntityGateway {
    
    private static let databaseName = "Models"
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: databaseName)
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var ensemble: CDEPersistentStoreEnsemble! = {
        let managedObjectModelURL = Bundle.main.url(forResource: databaseName, withExtension: "momd")
        let persistentStore = self.persistentContainer.persistentStoreCoordinator.persistentStores.last?.url
        let ensemble = CDEPersistentStoreEnsemble(
            ensembleIdentifier: databaseName,
            persistentStore: persistentStore,
            managedObjectModelURL: managedObjectModelURL,
            cloudFileSystem: CDEICloudFileSystem(ubiquityContainerIdentifier: nil)
        )
        ensemble?.delegate = self
        
        return ensemble
    }()
    
    func transactions(forDate date: Date) -> [Transaction]? {
        var transactions: [Transaction]?
        managedObjectContext.performAndWait {
            let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            let startOfDay = Calendar.current.startOfDay(for: date)
            let endOfDay = Calendar.current.date(bySetting: .day, value: 1, of: startOfDay)!
            request.predicate = NSPredicate(
                format: "creationDate >= %@ AND creationDate < %@",
                startOfDay as NSDate,
                endOfDay as NSDate
            )
            do {
                transactions = try request.execute()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return transactions
    }
    
    func makeCategory() -> Category {
        let category = Category(context: managedObjectContext)
        category.group = CategoryGroup(context: managedObjectContext)
        return category
    }
    
    func makeTransaction() -> Transaction {
        return Transaction(context: managedObjectContext)
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }
    
    func delete(transaction: Transaction) {
        managedObjectContext.delete(transaction)
    }
    
    func categories() -> [Category]? {
        var categories: [Category]?
        managedObjectContext.performAndWait {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            do {
                categories = try request.execute()
            } catch {
                print(error)
            }
        }
        return categories
    }
    
    func categoryBy(uniqueIdentifier : String) -> Category? {
        var category: Category?
        managedObjectContext.performAndWait {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            request.predicate = NSPredicate(format: "uniqueIdentifier = %@", uniqueIdentifier)
            do {
                category = (try request.execute()).first
            } catch {
                print(error)
            }
        }
        return category
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SQLiteMemoryPersistent.managedObjectContextDidSave(_:)),
            name: Notification.Name.CDEMonitoredManagedObjectContextDidSave,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SQLiteMemoryPersistent.iCouldFileSystemDidDownloadFiles(_:)),
            name: Notification.Name.CDEICloudFileSystemDidDownloadFiles,
            object: nil
        )
    }
    
    func managedObjectContextDidSave(_ notification: Notification) {
        synchonize()
    }
    
    func iCouldFileSystemDidDownloadFiles(_ notification: Notification) {
        synchonize()
    }
    
    func synchonize(_ completion: (() -> ())? = nil) {
        if !ensemble.isLeeched {
            ensemble.leechPersistentStore(completion: { error in
                completion?()
            })
        } else {
            ensemble.merge(completion: { error in
                completion?()
            })
        }
    }
}

extension SQLiteMemoryPersistent: CDEPersistentStoreEnsembleDelegate {
    func persistentStoreEnsemble(_ ensemble: CDEPersistentStoreEnsemble!, didSaveMergeChangesWith notification: Notification!) {
        managedObjectContext.mergeChanges(fromContextDidSave: notification)
    }
    
    func persistentStoreEnsemble(_ ensemble: CDEPersistentStoreEnsemble!, globalIdentifiersForManagedObjects objects: [Any]!) -> [Any]! {
        
        return (objects as NSArray).value(forKeyPath: "uniqueIdentifier") as! [Any]
    }
}
