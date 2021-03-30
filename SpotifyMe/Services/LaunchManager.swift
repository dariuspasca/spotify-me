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

    weak var userSession: UserSession?
    weak var authorizationDelegate: LaunchManagerDelegate!
    let sessionManager = UserSessionManager()

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

            SpotifyService.shared.getAccessToken { (res) in
                switch res {
                case .success(let response):
                    self.sessionManager.createUserSession(authorization: response, authorizationCode: authorizationCode)
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
