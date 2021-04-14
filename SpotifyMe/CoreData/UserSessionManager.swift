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

    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext ) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }

    // MARK: - CREATE

    func createUserSession(authorization: AccessAuthorization, authorizationCode: String) {
        backgroundContext.performAndWait {
            let userSession = UserSession(context: backgroundContext)
            userSession.accessToken = authorization.accessToken
            userSession.expireAt = Date().addingTimeInterval(TimeInterval(authorization.expiresIn - 300))
            userSession.refreshToken = authorization.refreshToken
            userSession.authorizationCode = authorizationCode

            do {
                try backgroundContext.save()
            } catch {
                os_log("Failed to create user session with error: %@", type: .error, String(describing: error))
            }
        }
    }

    // MARK: - UPDATE

    func updateUserSession(userSession: UserSession) {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
            } catch {
                os_log("Failed to update user session with error: %@", type: .error, String(describing: error))
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
            do {
                userSession = try mainContext.fetch(fetchRequest).first
            } catch {
                os_log("Failed to fetch user session with error: %@", type: .error, String(describing: error))
            }
        }
        return userSession
    }

}
