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
    let mainContext: NSManagedObjectContext

    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext ) {
        self.mainContext = mainContext
    }

    // swiftlint:disable:next all
    func createUserProfile(displayName: String?, email: String, product: String, profileUri: URL, followers: Int16?, image: URL?) {
        let user = UserProfile(context: self.mainContext)
        user.displayName = displayName
        user.email = email
        user.product = product
        user.profileUri = profileUri
        user.profileImage = image

        if let followersCount = followers {
            user.followers = followersCount
        }

        do {
            try self.mainContext.save()
            os_log("Saved new UserProfile", type: .info)
        } catch {
            os_log("Failed to save new UserProfile with error: %@", type: .error, String(describing: error))
        }
    }

    func updateUserSession(userSession: UserSession) {
        do {
            try self.mainContext.save()
            os_log("UserProfile updated", type: .info)
        } catch {
            os_log("Failed to update UserProfile with error: %@", type: .error, String(describing: error))
        }
    }

    func fetchUserProfile() -> UserProfile? {
        do {
            os_log("Fetching UserProfile", type: .info)
            let fetchRequest = NSFetchRequest<UserProfile>(entityName: "UserProfile")
            var userProfile: UserProfile?
            do {
                userProfile = try self.mainContext.fetch(fetchRequest).first
            } catch {
                os_log("Failed to fetch UserSession", type: .info)
            }

            return userProfile
        }
    }

}
