//
//  History.swift
//  phonepeTask
//
//  Created by hasiyar on 28/03/18.
//  Copyright © 2018 hos.lbox.phonepeTask. All rights reserved.
//

import UIKit
import CoreData
class History: NSManagedObject
{
    static func createHistoryEntiryFrom(context:NSManagedObjectContext, date:Date , text:String) -> NSManagedObject? {
        
        if let historyEntity = NSEntityDescription.insertNewObject(forEntityName: "History", into: context) as? History {
            historyEntity.text = text
            historyEntity.date = date
            return historyEntity
        }
        return nil
    }
    
    
    static  func getHistoryData()-> Array<History>?
    {
        let fetchRequest:NSFetchRequest<History> = History.fetchRequest()
        fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 10
        // CoreDataManager.sharedManager.persistentContainer.performBackgroundTask { (backContext) in
        do
        {
            let searchHistory = try CoreDataManager.sharedManger.managedObjectContext.fetch(fetchRequest)
            print(searchHistory.count)
            return searchHistory
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        // }
        return nil
    }
    
    static  func getHistoryDataWithPredicateText(text:String)-> Array<History>?
    {
        let fetchRequest:NSFetchRequest<History> = History.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "text  CONTAINS[c] %@",text )
        fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 10
        // CoreDataManager.sharedManager.persistentContainer.performBackgroundTask { (backContext) in
        do
        {
            let searchHistory = try CoreDataManager.sharedManger.managedObjectContext.fetch(fetchRequest)
            return searchHistory
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        // }
        return nil
    }
}
