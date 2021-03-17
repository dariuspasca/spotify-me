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
        profileManager = UserProfileManager(mainContext: coreDataStack.mainContext)
    }

    func testCreateSession() {
        // swiftlint:disable:next line_length
        _ = profileManager.createUserProfile(displayName: "Test", email: "user@test.com", product: "premium", followers: 7, image: nil)
        let profile = profileManager.fetchUserProfile()

        XCTAssertEqual("Test", profile?.displayName)
    }

    func testUpdateSession() {
        // swiftlint:disable:next line_length
        let profile = profileManager.createUserProfile(displayName: "Test", email: "user@test.com", product: "premium", followers: 7, image: nil)!
        profile.followers = 10
        profileManager.updateUserProfile(userProfile: profile)
        let updatedProfile = profileManager.fetchUserProfile()!

        XCTAssertEqual(10, updatedProfile.followers)

    }

}
