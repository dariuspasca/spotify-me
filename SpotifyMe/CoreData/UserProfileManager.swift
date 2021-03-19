//
//  UserProfileManager.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 15/03/21.
//

import Foundation
import CoreData
import os.log

class UserProfileManager {
    let mainContext: NSManagedObjectContext // Reading
    let backgroundContext: NSManagedObjectContext // Writing

    // MARK: - INIT

    // swiftlint:disable:next line_length
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext ) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }

    // MARK: - CREATE

    // swiftlint:disable:next all
    func createUserProfile(displayName: String?, email: String, product: String, followers: Int16?, image: URL?, session: UserSession) {
        backgroundContext.performAndWait {
            // swiftlint:disable:next all
            let user = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: backgroundContext) as! UserProfile
            user.displayName = displayName
            user.email = email
            user.product = product
            user.profileImage = image
            user.session = session

            if let followersCount = followers {
                user.followers = followersCount
            }

            do {
                try self.backgroundContext.save()
                os_log("Created new UserProfile", type: .info)
            } catch {
                os_log("Failed to create new UserProfile with error: %@", type: .error, String(describing: error))
            }
        }
    }

    // MARK: - UPDATE

    func updateUserProfile(userProfile: UserProfile) {
        backgroundContext.performAndWait {

            do {
                try self.backgroundContext.save()
                os_log("UserProfile updated", type: .info)
            } catch {
                os_log("Failed to update UserProfile with error: %@", type: .error, String(describing: error))
            }
        }

    }

    // MARK: - Fetch

    func fetchUserProfile(withEmail email: String) -> UserProfile? {
        do {
            let fetchRequest = NSFetchRequest<UserProfile>(entityName: "UserProfile")
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)

            var userProfile: UserProfile?
            mainContext.performAndWait {
                do {
                    os_log("Fetching UserProfile", type: .info)
                    userProfile = try self.mainContext.fetch(fetchRequest).first
                } catch {
                    os_log("Failed to fetch UserSession", type: .info)
                }
            }

            return userProfile
        }
    }

}
