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

protocol LaunchManagerDelegate: AnyObject {
    func didCompleteAuthorization(ready: Bool)
}

class LaunchManager {

    var userSession: UserSession?
    weak var authorizationDelegate: LaunchManagerDelegate!
    let spotifyApi = SpotifyApi.init()
    let sessionManager = UserSessionManager()

    func isUserConnected(with authorizationCode: String?) -> Bool {
        guard authorizationCode != nil else {
            return false
        }

        let userSession = self.sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode!)

        if (userSession != nil) {
            return true
        } else {
            return false
        }
    }

    public func handleURL(url: URL) {
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
                    self.authorizationDelegate.didCompleteAuthorization(ready: true)
                case .failure(let err):
                    self.authorizationDelegate.didCompleteAuthorization(ready: false)
                    os_log("Request to access and refresh token failed with error: %@", type: .error, String(describing: err))
                }
            }
        } else {
            os_log("Unrecognised URL type; handling not possible.", type: .error, url.absoluteString)
        }
    }
}
