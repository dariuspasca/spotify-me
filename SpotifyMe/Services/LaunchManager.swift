//
//  LaunchManager.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 15/03/21.
//

import Foundation
import CoreData
import UIKit
import os.log

class LaunchManager {

    var userSession: UserSession?
    let spotifyApi = SpotifyApi.init()
    let sessionManager = UserSessionManager()

    func handleApplicationDidBecomeActive() {
        let authorizationCode = UserDefaults.standard.string(forKey: "authorizationCode")

        guard authorizationCode != nil else {
            // Should redirect to login
            os_log("No UserSession", type: .info)
            return
        }

        userSession = self.sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode!)

        guard userSession != nil else {
            os_log("No UserSession found with authorizationCode %@", type: .error, String(describing: authorizationCode!))
            return
        }
        controlTokenValidity()
    }

    func controlTokenValidity() {
        os_log("Verifying accessToken validity", type: .info)
        guard (userSession?.isExpired) != true else {
            os_log("accessToken expired", type: .info)
            refreshToken()
            return
        }
        os_log("accessToken is valid", type: .info)
    }

    private func refreshToken() {
        os_log("Refreshing accessToken", type: .info)
        spotifyApi.requestRefreshAccessToken(refreshToken: userSession!.refreshToken!) { (res) in
            switch res {
            case .success(let response):
                DispatchQueue.main.async {
                    // Update UserSession object
                    self.userSession!.accessToken = response.accessToken
                    self.userSession!.expireAt = Date().addingTimeInterval(TimeInterval(response.expiresIn - 300))
                    // Save data
                    self.sessionManager.updateUserSession(userSession: self.userSession!)
                }
            case .failure(let err):
                os_log("Request to refresh accessToken failed with error: %@", type: .error, String(describing: err))
            }
        }
    }

    public func handleURL(url: URL) {
        // A host, a path and query params are expected, else the URL will not be handled.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host,
              let params = components.queryItems else {
            os_log("Invalid URL. Host, path and query params are expected", type: .info)
            return
        }
        // Handle Spotify authorization flow
        if host == "spotify-login-callback" {
            os_log("Handling spotify login callback", type: .info)

            // Save authorization code
            let authorizationCode = params[0].value!
            UserDefaults.standard.setValue(authorizationCode, forKey: "authorizationCode")

            spotifyApi.requestAccessAndRefreshToken { (res) in
                switch res {
                case .success(let response):

                    // swiftlint:disable:next line_length
                    self.sessionManager.createUserSession(accessToken: response.accessToken, expiresIn: response.expiresIn, refreshToken: response.refreshToken!, authorizationCode: authorizationCode)
                case .failure(let err):
                    os_log("Request to access and refresh token failed with error: %@", type: .error, String(describing: err))
                }
            }
        } else {
            os_log("Unrecognised URL type; handling not possible.", type: .error, url.absoluteString)
        }
    }
}
