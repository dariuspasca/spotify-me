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
    let mainContext: NSManagedObjectContext

    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext ) {
        self.mainContext = mainContext
    }

    func createUserSession(accessToken: String, expiresIn: Int, refreshToken: String) -> UserSession? {
        let userSession = UserSession(context: self.mainContext)
        userSession.accessToken = accessToken
        userSession.expireAt = Date().addingTimeInterval(TimeInterval(expiresIn - 300))
        userSession.refreshToken = refreshToken

        do {
            try self.mainContext.save()
            os_log("Saved new UserSession", type: .info)
            return userSession
        } catch {
            os_log("Failed to save UserSession with error: %@", type: .error, String(describing: error))
        }

        return nil
    }

    func updateUserSession(userSession: UserSession) {
        do {
            try self.mainContext.save()
            os_log("UserSession updated", type: .info)
        } catch {
            os_log("Failed to update UserSession with error: %@", type: .error, String(describing: error))
        }
    }

    func fetchUserSession() -> UserSession? {
        do {
            os_log("Fetching UserSession", type: .info)
            let fetchRequest = NSFetchRequest<UserSession>(entityName: "UserSession")
            var userSession: UserSession?
            do {
                userSession = try self.mainContext.fetch(fetchRequest).first
            } catch {
                os_log("Failed to fetch UserSession", type: .info)
            }

            return userSession
        }
    }

}
