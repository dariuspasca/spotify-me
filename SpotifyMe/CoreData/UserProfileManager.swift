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

    func createUserProfile(userObj: PrivateUser, sessionId: NSManagedObjectID?) {
        backgroundContext.performAndWait {
            let user = UserProfile(context: backgroundContext)
            user.displayName = userObj.displayName
            user.email = userObj.email
            user.product = userObj.product

            if sessionId != nil {
                user.session = backgroundContext.object(with: sessionId!) as? UserSession
            }

            if let followersCount = userObj.followers?.total {
                user.followers = Int16(followersCount)
            }

            if let image = userObj.images?.first {
                user.profileImage = image.url
            }

            do {
                try self.backgroundContext.save()
                os_log("Created user with email '%@'", type: .info, String(describing: user.email))
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
                os_log("Updated user with email '%@'", type: .info, String(describing: userProfile.email))
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
                    os_log("Fetching user with email '%@'", type: .info, String(describing: email))
                    userProfile = try self.mainContext.fetch(fetchRequest).first
                } catch {
                    os_log("Failed to fetch UserSession", type: .info)
                }
            }

            return userProfile
        }
    }

}
