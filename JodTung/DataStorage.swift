//
//  SQLiteMemoryPersistent.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/11/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import CoreData
import Ensembles

protocol EntityGateway {
    func save()
    
    func categoryGroupsCount() -> Int?
    
    func categoryGroups() -> [CategoryGroup]?
    
    func makeCategoryGroup() -> CategoryGroup
    
    func categoryGroupBy(uniqueIdentifier: String) -> CategoryGroup?
    
    func categories() -> [Category]?
    
    func categories(ofGroup categoryGroup: CategoryGroup) -> [Category]?
    
    func makeCategory() -> Category
    
    func categoryBy(uniqueIdentifier: String) -> Category?
    
    func transactions(ofDate date: Date) -> [Transaction]?
    
    func transactionCount(ofDate date: Date) -> Int?
    
    func makeTransaction() -> Transaction
    
    func delete(transaction: Transaction)
}

class DataStorage: NSObject, EntityGateway {
    
    // MARK: - Properties
    
    private static let databaseName = "Models"
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: databaseName)
        
        if self.storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.type = StorageType.sqlite.value
            container.persistentStoreDescriptions = [description]
        }
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
    
    // MARK: - Storage Type
    
    enum StorageType {
        case sqlite, inMemory
        
        var value: String {
            switch self {
            case .sqlite:
                return NSSQLiteStoreType
            case .inMemory:
                return NSInMemoryStoreType
            }
        }
    }
    
    private var storageType: StorageType
    
    // MARK: - Object lifecycle
    
    init(storageType: StorageType) {
        
        self.storageType = storageType
        
        super.init()
    
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(DataStorage.managedObjectContextDidSave(_:)),
            name: Notification.Name.CDEMonitoredManagedObjectContextDidSave,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(DataStorage.iCouldFileSystemDidDownloadFiles(_:)),
            name: Notification.Name.CDEICloudFileSystemDidDownloadFiles,
            object: nil
        )
    }
    
    // MARK: - Ensemble synchonization
    
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
    
    // MARK: - Save
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Category Group
    
    func categoryGroupsCount() -> Int? {
        var categoryGroupsCount: Int?
        managedObjectContext.performAndWait {
            let request: NSFetchRequest<CategoryGroup> = CategoryGroup.fetchRequest()
            do {
                categoryGroupsCount = try self.managedObjectContext.count(for: request)
            } catch {
                print(error)
            }
        }
        return categoryGroupsCount
    }
    
    func categoryGroups() -> [CategoryGroup]? {
        var categoryGroups: [CategoryGroup]?
        managedObjectContext.performAndWait {
            let request: NSFetchRequest<CategoryGroup> = CategoryGroup.fetchRequest()
            do {
                categoryGroups = try request.execute()
            } catch {
                print(error)
            }
        }
        return categoryGroups
    }
    
    func makeCategoryGroup() -> CategoryGroup {
        return CategoryGroup(context: managedObjectContext)
    }
    
    func categoryGroupBy(uniqueIdentifier: String) -> CategoryGroup? {
        var categoryGroup: CategoryGroup?
        managedObjectContext.performAndWait {
            let request: NSFetchRequest<CategoryGroup> = CategoryGroup.fetchRequest()
            request.predicate = NSPredicate(format: "uniqueIdentifier = %@", uniqueIdentifier)
            do {
                categoryGroup = (try request.execute()).first
            } catch {
                print(error)
            }
        }
        return categoryGroup
    }
    
    // MARK: - Category
    
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
    
    func makeCategory() -> Category {
        let category = Category(context: managedObjectContext)
        return category
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
    
    func categories(ofGroup categoryGroup: CategoryGroup) -> [Category]? {
        var categories: [Category]?
        managedObjectContext.performAndWait {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            request.predicate = NSPredicate(format: "group = %@", categoryGroup)
            do {
                categories = try request.execute()
            } catch {
                print(error)
            }
        }
        return categories
    }
    
    // MARK: - Transaction
    
    func transactions(ofDate date: Date) -> [Transaction]? {
        var transactions: [Transaction]?
        managedObjectContext.performAndWait {
            let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            let startOfDay = Calendar.current.startOfDay(for: date)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            request.predicate = NSPredicate(
                format: "creationNSDate >= %@ AND creationNSDate < %@",
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
    
    func transactionCount(ofDate date: Date) -> Int? {
        var count: Int?
        managedObjectContext.performAndWait {
            let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            do {
                count = try self.managedObjectContext.count(for: request)
            } catch {
                print(error)
            }
        }
        return count
    }
    
    func makeTransaction() -> Transaction {
        return Transaction(context: managedObjectContext)
    }
    
    func delete(transaction: Transaction) {
        managedObjectContext.delete(transaction)
    }
}

extension DataStorage: CDEPersistentStoreEnsembleDelegate {
    func persistentStoreEnsemble(_ ensemble: CDEPersistentStoreEnsemble!, didSaveMergeChangesWith notification: Notification!) {
        managedObjectContext.mergeChanges(fromContextDidSave: notification)
    }
    
    func persistentStoreEnsemble(_ ensemble: CDEPersistentStoreEnsemble!, globalIdentifiersForManagedObjects objects: [Any]!) -> [Any]! {
        
        return (objects as NSArray).value(forKeyPath: "uniqueIdentifier") as! [Any]
    }
}
