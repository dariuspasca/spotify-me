//
//  UserSession+CoreDataProperties.swift
//  
//
//  Created by Darius Pasca on 14/03/21.
//
//

import Foundation
import CoreData

extension UserSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSession> {
        return NSFetchRequest<UserSession>(entityName: "UserSession")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var expireAt: Date?
    @NSManaged public var refreshToken: String?

}
