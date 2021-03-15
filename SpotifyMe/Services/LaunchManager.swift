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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let spotifyApi = SpotifyApi.init()
    
    func handleApplicationDidBecomeActive() {
        fetchUserSession()
        
        guard (userSession != nil) else {
            // Should redirect to login
            os_log("No user session", type: .info)
            return
        }
        controlTokenValidity()
    }
    
    func controlTokenValidity() {
        os_log("Control if access token is still valid", type: .info)
        guard (userSession?.isExpired) != nil else {
            refreshToken()
            return
        }
        
        os_log("Access token is still valid", type: .info)
        
    }
    
    private func fetchUserSession() {
        do {
            os_log("Fetching user session", type: .info)
            self.userSession = try context.fetch(UserSession.fetchRequest()).first
        } catch  {
            os_log("Failed to fetch user session with error: %@", type:.error, String(describing: error))
        }
    }
    
    private func refreshToken(){
        os_log("Access token not valid, refreshing", type: .info)
        spotifyApi.requestRefreshAccessToken(refreshToken: userSession!.refreshToken!) { (res) in
            switch res {
            case .success(let response):
                
                // Update user session object
                self.userSession!.accessToken = response.accessToken
                self.userSession!.expireAt = Date().addingTimeInterval(TimeInterval(response.expiresIn - 300))
                
                // Save data
                do {
                    try self.context.save()
                    os_log("User session updated with refreshed access token", type: .info)
                } catch  {
                    os_log("Failed to save user session with error: %@", type:.error, String(describing: error))
                }
                
                
            case .failure(let err):
                os_log("Request to refresh access token failed with error: %@", type:.error, String(describing: err))
            }
        }
    }
    
    public func handleURL(url: URL) {
        // A host, a path and query params are expected, else the URL will not be handled.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host,
              let _ = components.path,
              let params = components.queryItems else {
            os_log("Invalid URL. Host, path and query params are expected", type: .info)
            return
        }
        
        // Handle Spotify authorization flow
        if (host == "spotify-login-callback") {
            os_log("Handling spotify login callback", type: .info)
            
            // Save authorization code
            UserDefaults.standard.setValue(params[0].value!, forKey: "authorizationCode")
            
            spotifyApi.requestAccessAndRefreshToken { (res) in
                switch res {
                case .success(let response):
                    
                    // Create a user session object
                    let userSession = UserSession(context: self.context)
                    userSession.accessToken = response.accessToken
                    userSession.expireAt = Date().addingTimeInterval(TimeInterval(response.expiresIn - 300))
                    userSession.refreshToken = response.refreshToken
                    
                    // Save data
                    do {
                        try self.context.save()
                        os_log("Saved new user session", type: .info)
                    } catch  {
                        os_log("Failed to save user session with error: %@", type:.error, String(describing: error))
                    }
                    
                    
                case .failure(let err):
                    os_log("Request to access and refresh token failed with error: %@", type:.error, String(describing: err))
                }
            }
        }
        else {
            os_log("Unrecognised URL type; handling not possible.", type: .error, url.absoluteString)
        }
    }
}

