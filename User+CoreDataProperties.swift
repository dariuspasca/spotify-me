//
//  User+CoreDataProperties.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 15/03/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var displayName: String?
    @NSManaged public var email: String?
    @NSManaged public var followers: Int16
    @NSManaged public var profileImage: URL?
    @NSManaged public var product: String?
    @NSManaged public var profileUri: URL?

}

extension User : Identifiable {

}
