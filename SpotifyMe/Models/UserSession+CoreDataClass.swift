//
//  UserSession+CoreDataClass.swift
//  
//
//  Created by Darius Pasca on 14/03/21.
//
//

import Foundation
import CoreData

@objc(UserSession)
public class UserSession: NSManagedObject {

    var authorizationValue: String {
        return "Bearer \(accessToken!)"
    }

    var isExpired: Bool {
        return Date() > expireAt!
    }

}
