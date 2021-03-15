//
//  CoreDataStack.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 15/03/21.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistentContainer:NSPersistentContainer
    let backgroundContext:NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "SpotifyMe")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        
        persistentContainer.loadPersistentStores(completionHandler: { (description, error) in
                                                    guard error == nil else {
                                                        fatalError("Unable to load store \(error!)")
                                                    }})
        
        mainContext = persistentContainer.viewContext
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }
}

