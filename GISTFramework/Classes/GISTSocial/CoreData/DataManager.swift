//
//  DataManager.swift
//  E-Grocery
//
//  Created by Muneeba on 1/14/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit
import CoreData

public var DATA_MANAGER:DataManager {
    get {
        return DataManager.sharedManager;
    }
} //P.E.

public var MANAGED_CONTEXT:NSManagedObjectContext {
    get {
        return DataManager.sharedManager.managedObjectContext;
    }
} //P.E.

public class DataManager: NSObject {
    
    private var _dataBaseModel:String? = nil;
    private var dataBaseModel:String {
        if (_dataBaseModel == nil) {
            _dataBaseModel = SyncedConstants.constant(forKey: "databaseFileName") ?? "CoreData";
        }
        
        return _dataBaseModel!; // momd file
    } //F.E.
    
    private var _dataBaseName:String? = nil;
    private var dataBaseName:String {
        if (_dataBaseName == nil) {
            let modFile:String = self.dataBaseModel;
            let version:String = AppInfo.versionNBuildNumber;//SyncedConstants.constant(forKey: "databaseVersion") ?? "V1.0";
            
            _dataBaseName = "\(modFile)_\(version).sqlite";
        }
        
        return _dataBaseName!;
    } //F.E.
    
    public static var sharedManager: DataManager = DataManager();
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.dataBaseModel, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.dataBaseName);
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    // MARK: - Core Data Saving support
    public func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    } // F.E.
    
    public func checkIfObjectExists(_ entityName:String, key:String, value:String)-> Bool {
        let count:Int = self.fetchObjectsCountForEntity(entityName, queryString: "\(key)==\(value)");
        //--
        return (count>0);
    } //F.E
    
    public func fetchObjectsCountForEntity(_ entityName:String, queryString:String?)-> Int {
        let predicate:NSPredicate? = (queryString == nil) ? nil: NSPredicate(format: queryString!, argumentArray: nil);
        //--
        return self.fetchObjectsCountForEntity(entityName, predicate:predicate);
    } //F.E.
    
    public func fetchObjectsCountForEntity(_ entityName:String, predicate:NSPredicate?)-> Int {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>();
        
        //--setting entity to fetch request
        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
        fetchRequest.entity = entity
        
        //--- predicate for fetch request
        fetchRequest.predicate = predicate
        
        fetchRequest.includesPropertyValues = false;
        fetchRequest.includesSubentities = false;
        
        var count:Int = 0;
        
        do {
            count = try self.managedObjectContext.count(for: fetchRequest)
        }
        catch {
            print(error.localizedDescription);
        }
        
        return count
    } //F.E.
    
    public func fetchObjectsForEntityName<T:NSFetchRequestResult>(_ entityName:String, predicate:NSPredicate?, descriptor:NSSortDescriptor?)->[T] {
        return fetchObjectsForEntityName(entityName, predicate:predicate, descriptors: (descriptor == nil) ?nil:[descriptor!]);
    } //F.E.
    
    public func fetchObjectsForEntityName<T:NSFetchRequestResult>(_ entityName:String, predicate:NSPredicate?, descriptors:[NSSortDescriptor]?)->[T] {
        
        var rtnArr:[T]?
        
        let fetchRequest:NSFetchRequest<T> = NSFetchRequest<T>(entityName:entityName);
        
        // setting sort descriptor to fetch request
        fetchRequest.sortDescriptors = descriptors ;//[descriptor!]
        
        // predicate for fetch request
        fetchRequest.predicate = predicate
        
        do {
            rtnArr = try self.managedObjectContext.fetch(fetchRequest)
        }
        catch{
            print(error.localizedDescription);
        }
        
        return rtnArr!;
    } //F.E.
    
    public func fetchObjectsForEntityNameWithSection(_ entityName:String, predicate:NSPredicate?, descriptors:[NSSortDescriptor]?, sectionName: String)->NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        // setting sort descriptor to fetch request
        fetchRequest.sortDescriptors = descriptors ;//[descriptor!]
        
        // predicate for fetch request
        fetchRequest.predicate = predicate
        
        let fetchRequestController:NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: sectionName, cacheName: nil)
        
        do {
            try fetchRequestController.performFetch()
        } catch {
            print("An error occurred")
        }
        
        return fetchRequestController;
    } //F.E.
    
    public func insertSingleObjectForEntityName<T:NSManagedObject>(_ entityName: String, uniquekey key:String, uniquekeyValue value:Any) -> T {
        
        var managedObj:NSManagedObject?;
        
        let arr :[T] = DATA_MANAGER.fetchObjectsForEntityName(entityName, predicate: NSPredicate(format: "\(key)==\(value)"), descriptor: nil);
        
        managedObj = arr.first;
        
        if(managedObj == nil){
            managedObj = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.managedObjectContext);
            //--
            managedObj?.setValue(value, forKey: key);
        }
        
        return managedObj as! T;
    } //F.E.
    
    public func deleteObjectsForEntityName(_ entityName:String, predicate:NSPredicate?){
        let arr:[NSManagedObject] = self.fetchObjectsForEntityName(entityName, predicate: predicate, descriptor: nil);
        
        for item in arr {
            self.managedObjectContext.delete(item);
        }
        
        self.saveContext();
    } //F.E.
    
    @available(iOS 9.0, *)
    public func deleteAllObjectsForEntityName(_ entityName:String) {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName:entityName);
       
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.persistentStoreCoordinator.execute(deleteRequest, with: self.managedObjectContext);
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    } //F.E.
    
    public func deleteAllData() {
        let entities:[NSEntityDescription] = self.managedObjectModel.entities;
        
        for entity in entities {
            if #available(iOS 9.0, *) {
                self.deleteAllObjectsForEntityName(entity.name!)
            } else {
                // Fallback on earlier versions
            };
        }
    } //F.E.

} //CLS END

@objc public protocol ManagedProtocol {
    static var entityName:String {get};
    static var uniqueKey:String {get};
    
    static func addEntry(_ data:[String:Any], saveContext:Bool) -> ManagedProtocol;
}

public extension ManagedProtocol {
    static public func addEntries<T:ManagedProtocol>(_ objectArray: NSArray, cleanup:Bool = false) -> [T]? {
        
        guard objectArray.count > 0 else {
            
            if (cleanup) {
                self.cleanup();
            }
            
            return [];
        }
        
        var rtnArr:[AnyObject] = [];
        
        var uniqueValues:[Int] = [];
        
        for i in 0 ..< objectArray.count{
            let mObj:ManagedProtocol = self.addEntry(objectArray[i] as! [String:Any], saveContext: false)
            
            if cleanup == true, let uValue:Int = (mObj as? NSManagedObject)?.value(forKey: self.uniqueKey) as? Int {
                uniqueValues.append(uValue);
            }
            
            rtnArr.append(mObj);
        }
        
        DATA_MANAGER.saveContext();
        
        if (uniqueValues.count > 0) {
            DATA_MANAGER.deleteObjectsForEntityName(self.entityName, predicate: NSPredicate(format: "NOT (\(self.uniqueKey) IN %@)", uniqueValues))
        }
        
        return (rtnArr as? [T])
    } //F.E.
    
    public static func cleanup() {
        if #available(iOS 9.0, *) {
            DATA_MANAGER.deleteAllObjectsForEntityName(self.entityName)
        } else {
            // Fallback on earlier versions
        };
    }
}
