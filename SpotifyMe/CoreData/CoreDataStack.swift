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

    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext

    // MARK: - Core Data stack

    private init() {
        persistentContainer = NSPersistentContainer(name: "SpotifyMe")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        persistentContainer.loadPersistentStores { (_, error) in
            guard error == nil else {
                fatalError("Unable to load store \(error!)")
            }
        }

        mainContext = persistentContainer.viewContext
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }

    func saveMainContext() {
        if mainContext.hasChanges {
            do {
                print("Saving context")
                try mainContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Failed to save context with error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
