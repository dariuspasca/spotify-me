//
//  SpotifyAuthorization.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 29/03/21.
//

import Foundation

struct SpotifyAuthorizationConfig {
    static let clientId = ProcessInfo.processInfo.environment["client_id"]!
    static let clientSecret = ProcessInfo.processInfo.environment["client_secret"]!
    // swiftlint:disable line_length
    static let scopes = "user-read-private user-read-email playlist-read-collaborative playlist-read-private user-read-private user-read-email user-library-read user-top-read user-read-recently-played"
    static let redirectUri = "spotifyMe://spotify-login-callback"

    static func authorizationRequestURL() -> URL {
        var urlComponents = URLComponents(string: "https://accounts.spotify.com/authorize")!

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "scope", value: scopes)
        ]

        return urlComponents.url!
    }

    static func clientAuthorizationKey() -> String {
        let base64ClientKey = "Basic \((clientId + ":" + clientSecret).data(using: .utf8)!.base64EncodedString())"
        return base64ClientKey
    }
}
