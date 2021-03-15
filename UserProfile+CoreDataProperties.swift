//
//  UserProfile+CoreDataProperties.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 15/03/21.
//
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var displayName: String?
    @NSManaged public var email: String?
    @NSManaged public var followers: Int16
    @NSManaged public var profileImage: URL?
    @NSManaged public var product: String?
    @NSManaged public var profileUri: URL?

}

extension UserProfile : Identifiable {

}
