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

    func testCreateSession() {
        let email = "user@test.com"
        profileManager.createUserProfile(displayName: "Test", email: email, product: "premium", followers: 7, image: nil)

        let profile = profileManager.fetchUserProfile(withEmail: "user@test.com")

        XCTAssertEqual(email, profile?.email)
    }

    func testUpdateSession() {
        let email = "user@test.com"
        profileManager.createUserProfile(displayName: "Test", email: email, product: "premium", followers: 7, image: nil)

        let profile = profileManager.fetchUserProfile(withEmail: email)!
        profile.followers = 10
        profileManager.updateUserProfile(userProfile: profile)

        let updatedProfile = profileManager.fetchUserProfile(withEmail: email)!

        XCTAssertEqual(10, updatedProfile.followers)
    }

}
