//
//  CoreDataManager.swift
//  Uber
//
//  Created by Tony Jin on 6/21/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//

import UIKit

class CoreDataManager: NSObject {
    
    //let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
    
    static let instance = CoreDataManager()
    
    class func shareInstance() -> CoreDataManager{
        return instance
    }
    
    func setupContextWithModelName(_ modelName: String) -> NSManagedObjectContext{
        
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        let url = Bundle.main.url(forResource: modelName, withExtension: "momd")
        let model = NSManagedObjectModel(contentsOf: url!)
        
        let store = NSPersistentStoreCoordinator(managedObjectModel: model!)
        
        //告诉coredata数据库的名字和路径
        let doc = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        let sqliteName = String(format: "%@.sqlite", modelName)
        //let sqlitePath = doc?.stringByAppendingString(sqliteName)
        let sqlitePath = (doc! as NSString).appendingPathComponent(sqliteName)
        print(sqlitePath)
        
        do {
            try store.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: URL(fileURLWithPath: sqlitePath), options: nil)
        } catch{
            print("error1")
        }
        
        context.persistentStoreCoordinator = store
        return context
    }

}
