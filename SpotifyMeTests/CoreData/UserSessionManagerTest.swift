//
//  UserSessionManagerTest.swift
//  SpotifyMeTests
//
//  Created by Darius Pasca on 16/03/21.
//

import XCTest
import CoreData
@testable import SpotifyMe

class UserSessionManagerTest: XCTestCase {

    var coreDataStack: CoreDataStackTest!
    var sessionManager: UserSessionManager!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStackTest()
        sessionManager = UserSessionManager(mainContext: coreDataStack.mainContext, backgroundContext: coreDataStack.backgroundContext)
    }

    func testCreateSession() {
        let authorizationCode = "FsFsoo7ZTFsw237asqsRAS"
        // swiftlint:disable:next line_length
        sessionManager.createUserSession(accessToken: "BQDOMq4_at2seFso7ZTFsw7qnu4iNfxJ", expiresIn: 3600, refreshToken: "seFso7ZTFsw7", authorizationCode: authorizationCode)
        let session = sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode)

        XCTAssertEqual("FsFsoo7ZTFsw237asqsRAS", session?.authorizationCode!)
    }

    func testUpdateSession() {
        let authorizationCode = "FsFsoo7ZTFsw237asqsRAS"
        // swiftlint:disable:next line_length
        sessionManager.createUserSession(accessToken: "BQDOMq4_at2seFso7ZTFsw7qnu4iNfxJ", expiresIn: 3600, refreshToken: "seFso7ZTFsw7", authorizationCode: authorizationCode)

        let session = sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode)!
        session.accessToken = "oFy8BhSH0ol0Xyv6qXE2P5u0pnEVyn1h"
        sessionManager.updateUserSession(userSession: session)

        let updatedSession = sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode)!

        XCTAssertEqual("oFy8BhSH0ol0Xyv6qXE2P5u0pnEVyn1h", updatedSession.accessToken!)

    }

}
