//
//  UserSessionManager.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 15/03/21.
//

import Foundation
import CoreData
import os.log

class UserSessionManager {
    let mainContext: NSManagedObjectContext // Reading
    let backgroundContext: NSManagedObjectContext // Writing

    // MARK: - INIT

    // swiftlint:disable:next line_length
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext ) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }

    // MARK: - CREATE

    func createUserSession(accessToken: String, expiresIn: Int, refreshToken: String, authorizationCode: String) {
        backgroundContext.performAndWait {
            let userSession = UserSession(context: backgroundContext)
            userSession.accessToken = accessToken
            userSession.expireAt = Date().addingTimeInterval(TimeInterval(expiresIn - 300))
            userSession.refreshToken = refreshToken
            userSession.authorizationCode = authorizationCode

            do {
                try backgroundContext.save()
                os_log("Created new UserSession", type: .info)
            } catch {
                os_log("Failed to create UserSession with error: %@", type: .error, String(describing: error))
            }
        }
    }

    // MARK: - UPDATE

    func updateUserSession(userSession: UserSession) {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
                os_log("UserSession updated", type: .info)
            } catch {
                os_log("Failed to update UserSession with error: %@", type: .error, String(describing: error))
            }
        }

    }

    // MARK: - FETCH

    func fetchUserSession(withAuthorizationCode authorizationCode: String) -> UserSession? {
        let fetchRequest = NSFetchRequest<UserSession>(entityName: "UserSession")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "authorizationCode == %@", authorizationCode)

        var userSession: UserSession?

        mainContext.performAndWait {
            os_log("Fetching UserSession", type: .info)
            do {
                userSession = try mainContext.fetch(fetchRequest).first
            } catch {
                os_log("Failed to fetch UserSession", type: .info)
            }
        }
        return userSession
    }

}
