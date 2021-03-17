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
        sessionManager = UserSessionManager(mainContext: coreDataStack.mainContext)
    }

    func testCreateSession() {
        // swiftlint:disable:next line_length
        _ = sessionManager.createUserSession(accessToken: "BQDOMq4_at2seFso7ZTFsw7qnu4iNfxJ", expiresIn: 3600, refreshToken: "seFso7ZTFsw7")
        let session = sessionManager.fetchUserSession()!

        XCTAssertEqual("BQDOMq4_at2seFso7ZTFsw7qnu4iNfxJ", session.accessToken!)
    }

    func testUpdateSession() {
        // swiftlint:disable:next line_length
        let session = sessionManager.createUserSession(accessToken: "BQDOMq4_at2seFso7ZTFsw7qnu4iNfxJ", expiresIn: 3600, refreshToken: "seFso7ZTFsw7")!
        session.accessToken = "oFy8BhSH0ol0Xyv6qXE2P5u0pnEVyn1h"
        sessionManager.updateUserSession(userSession: session)
        let updatedSession = sessionManager.fetchUserSession()!

        XCTAssertEqual("oFy8BhSH0ol0Xyv6qXE2P5u0pnEVyn1h", updatedSession.accessToken!)

    }

}
