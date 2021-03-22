//
//  UserSessionManagerTest.swift
//  SpotifyMeTests
//
//  Created by Darius Pasca on 16/03/21.
//

import XCTest
import CoreData
@testable import SpotifyMe

class UserProfileManagerTest: XCTestCase {

    var coreDataStack: CoreDataStackTest!
    var profileManager: UserProfileManager!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStackTest()
        profileManager = UserProfileManager(mainContext: coreDataStack.mainContext, backgroundContext: coreDataStack.backgroundContext)
    }

//    func testCreateSession() {
//        let email = "user@test.com"
//        profileManager.createUserProfile(displayName: "Test", email: email, product: "premium", followers: 7, image: nil, session: nil)
//
//        let profile = profileManager.fetchUserProfile(withEmail: "user@test.com")
//
//        XCTAssertEqual(email, profile?.email)
//    }
//
//    func testUpdateSession() {
//        let t = Explicit
//        let user = PrivateUser(displayName: "Test", email: "user@test.com", explicitContent:e, externalUrls:nil, followers: nil, href: "whatever.com", id: "2323", images: nil, product: "premium", type: "idk", uri: "whasas")
//        profileManager.createUserProfile(displayName: "Test", email: email, product: "premium", followers: 7, image: nil, session: nil)
//
//        let profile = profileManager.fetchUserProfile(withEmail: email)!
//        profile.followers = 10
//        profileManager.updateUserProfile(userProfile: profile)
//
//        let updatedProfile = profileManager.fetchUserProfile(withEmail: email)!
//
//        XCTAssertEqual(10, updatedProfile.followers)
//    }

}
