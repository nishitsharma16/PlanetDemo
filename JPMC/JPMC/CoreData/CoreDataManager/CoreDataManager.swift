//
//  CoreDataManager.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager : CoreDataStackProtocol {
    
    let momFileName = CoreDataConstants.fileName
    static let sharedInstance = CoreDataManager()
    private var mainContext : NSManagedObjectContext?
    private var privateContext : NSManagedObjectContext?
    
    private init() {
        
    }
    
    func initializeCoreDataStack(withCompletion completion : ((Bool) -> Void)?) {
        let bundle = Bundle(for: CoreDataManager.self)
        guard let modelURL = bundle.url(forResource: momFileName, withExtension: "momd") else {
            DispatchQueue.main.sync {
                if let handler = completion {
                    handler(false)
                }
            }
            return
        }
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            DispatchQueue.main.sync {
                if let handler = completion {
                    handler(false)
                }
            }
            return
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        mainContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        mainContext?.persistentStoreCoordinator = psc
        
        privateContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        privateContext?.parent = mainContext
        
        let sqlFileName = momFileName + ".sqlite"

        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                DispatchQueue.main.sync {
                    if let handler = completion {
                        handler(false)
                    }
                }
                return
            }
            
            let storeURL = docURL.appendingPathComponent(sqlFileName)
            
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true])
                DispatchQueue.main.sync {
                    if let handler = completion {
                        handler(true)
                    }
                }
            } catch {
                DispatchQueue.main.sync {
                    if let handler = completion {
                        handler(false)
                    }
                }
            }
        }
    }
    
    func deteleAllObjectsFromDB(withCompletion completion : ((Bool) -> Void)?) {
        if let privateMOC = self.privateContext {
            privateMOC.perform {
                do {
                    let request = NSFetchRequest<NSManagedObject>(entityName: "ProductCategory")
                    let results = try privateMOC.fetch(request)
                    for object in results {
                        privateMOC.delete(object)
                    }
                    self.saveContext(withCompletion: { (saved) in
                        if saved {
                            DispatchQueue.main.async {
                                if let completionHandler = completion {
                                    completionHandler(true)
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                if let completionHandler = completion {
                                    completionHandler(false)
                                }
                            }
                        }
                    })
                }
                catch {
                    DispatchQueue.main.async {
                        if let completionHandler = completion {
                            completionHandler(false)
                        }
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                if let completionHandler = completion {
                    completionHandler(false)
                }
            }
        }
    }
}

// Data Caching

extension CoreDataManager {
    
    func getData(forPath path : String, withCompletion completion : @escaping (Any?) -> Void) {
        if let privateMOC = self.privateContext {
            privateMOC.perform {
                do {
                    let request = NSFetchRequest<NSManagedObject>(entityName: CoreDataConstants.cacheEntityName)
                    let predicate = NSPredicate(format: "cacheKey == %@", path)
                    request.predicate = predicate
                    let results = try privateMOC.fetch(request)
                    let cacheMO = results.last
                    
                    DispatchQueue.main.async {
                        completion(cacheMO?.value(forKey: "cacheData"))
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func saveData(withData data : Any, forPath path : String, withCompletion completion : @escaping (Bool) -> Void) {
        if let privateMOC = self.privateContext
        {
            privateMOC.perform {
                let cacheMO = NSEntityDescription.insertNewObject(forEntityName: CoreDataConstants.cacheEntityName, into: privateMOC)
                cacheMO.setValue(data, forKey: "cacheData")
                cacheMO.setValue(path, forKey: "cacheKey")
                
                self.saveContext(withCompletion: { (saved) in
                    if saved {
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                })
            }
        }
    }
    
    func updateData(withData data : Any, forPath path : String, withCompletion completion : @escaping (Bool) -> Void) {
        if let privateMOC = self.privateContext {
            privateMOC.perform {
                do {
                    let request = NSFetchRequest<NSManagedObject>(entityName: CoreDataConstants.cacheEntityName)
                    let predicate = NSPredicate(format: "cacheKey == %@", path)
                    request.predicate = predicate
                    let results = try privateMOC.fetch(request)
                    if let cacheMO = results.last {
                        cacheMO.setValue(data, forKey: "cacheData")
                        self.saveContext(withCompletion: { (saved) in
                            if saved {
                                DispatchQueue.main.async {
                                    completion(true)
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                    completion(false)
                                }
                            }
                        })
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
}

// Private Method Extension

extension CoreDataManager {
    private func saveContext(withCompletion completion : ((Bool) -> Void)?) {
        if let moc = self.privateContext {
            if moc.hasChanges {
                do {
                    try moc.save()
                    if let mainMoc = self.mainContext
                    {
                        if mainMoc.hasChanges {
                            do {
                                try mainMoc.save()
                                if let handler = completion {
                                    handler(true)
                                }
                            }
                            catch let error {
                                NSLog("Unresolved error \(error)")
                                abort()
                            }
                        }
                    }
                }
                catch let error {
                    NSLog("Unresolved error \(error)")
                    abort()
                }
            }
        }
        else {
            if let handler = completion {
                handler(false)
            }
        }
    }
}

extension CoreDataManager {
    private struct CoreDataConstants {
        static let fileName = "PlanetData"
        static let cacheEntityName = "CacheData"
    }
}
