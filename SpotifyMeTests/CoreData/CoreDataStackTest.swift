//
//  CoreDataStack.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 15/03/21.
//

import Foundation
import CoreData
@testable import SpotifyMe

class CoreDataStackTest {
    static let shared = CoreDataStackTest()

    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext

    init() {
        persistentContainer = NSPersistentContainer(name: "SpotifyMe")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType

        // swiftlint:disable:next unused_closure_parameter
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
