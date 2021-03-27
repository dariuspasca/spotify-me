//
//  SpotifyApi.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 11/03/21.
//
// swiftlint:disable void_return

import Foundation
import Combine

struct SpotifyApi {

    private let clientId = "e230fefaed454e198ceb79d4e21ef20c"
    private let clientSecret = "dcfb7885665c4ca6b8f3e05756598259"
    // swiftlint:disable line_length
    private let scopes = "user-read-private user-read-email playlist-read-collaborative playlist-read-private user-read-private user-read-email user-library-read user-top-read user-read-recently-played"
    private let redirectUri = "spotifyMe://spotify-login-callback"

    func authorizationRequestURL() -> URL {
        var urlComponents = URLComponents(string: "https://accounts.spotify.com/authorize")!

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "scope", value: scopes)
        ]

        return urlComponents.url!
    }

    func requestAccessAndRefreshToken(completion: @escaping (Result<RefreshTokenResponse, Error>) -> ()) {

        var request = URLRequest(url: SpotifyEndpoint.tokenRequest.url)
        request.httpMethod = "POST"

        let base64ClientKey = "Basic \((clientId + ":" + clientSecret).data(using: .utf8)!.base64EncodedString())"

        // Header
        request.addValue(base64ClientKey, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        // Body
        var bodyComponent = URLComponents()
        bodyComponent.queryItems = [URLQueryItem(name: "grant_type", value: "authorization_code"),
                                    URLQueryItem(name: "code", value: UserDefaults.standard.string(forKey: "authorizationCode")!),
                                    URLQueryItem(name: "redirect_uri", value: redirectUri)]
        request.httpBody = bodyComponent.query?.data(using: .utf8)

        URLSession.shared.getResponse(for: request, responseType: RefreshTokenResponse.self) { (result) in
            completion(result)
        }
    }

    func requestRefreshAccessToken(refreshToken: String, completion: @escaping (Result<RefreshTokenResponse, Error>) -> ()) {
        let base64ClientKey = "Basic \((clientId + ":" + clientSecret).data(using: .utf8)!.base64EncodedString())"

        var request = URLRequest(url: SpotifyEndpoint.tokenRequest.url)
        request.httpMethod = "POST"
        request.addValue(base64ClientKey, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        var bodyComponent = URLComponents()
        bodyComponent.queryItems = [URLQueryItem(name: "grant_type", value: "refresh_token"),
                                    URLQueryItem(name: "refresh_token", value: refreshToken)]
        request.httpBody = bodyComponent.query?.data(using: .utf8)

        URLSession.shared.getResponse(for: request, responseType: RefreshTokenResponse.self) { (result) in
            completion(result)
        }
    }

    func fetchProfile(authorizationValue: String, completion: @escaping (Result<PrivateUser, Error>) -> ()) {
        var request = URLRequest(url: SpotifyEndpoint.userProfile.url)
        request.httpMethod = "GET"
        request.addValue(authorizationValue, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        URLSession.shared.getResponse(for: request, responseType: PrivateUser.self) { (result) in
            completion(result)
        }
    }

    func fetchPlaylists(authorizationValue: String, completion: @escaping (Result<Paginated<SimplifiedPlaylist>, Error>) -> ()) {
        var request = URLRequest(url: SpotifyEndpoint.myPlalists.url)
        request.httpMethod = "GET"
        request.addValue(authorizationValue, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        URLSession.shared.getResponse(for: request, responseType: Paginated<SimplifiedPlaylist>.self) { (result) in
            completion(result)
        }
    }

    // swiftlint:disable:next void_return
    func fetchTracks(authorizationValue: String, withUrl url:URL, completion: @escaping (Result<Paginated<PlaylistTrack>, Error>) -> ()) {
        var urlWithParams = URLComponents(string: url.absoluteString)!
        urlWithParams.queryItems = [
            URLQueryItem(name: "additional_types", value: "track")
        ]
        var request = URLRequest(url: urlWithParams.url!)
        request.httpMethod = "GET"
        request.addValue(authorizationValue, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        URLSession.shared.getResponse(for: request, responseType: Paginated<PlaylistTrack>.self) { (result) in
            completion(result)
        }

    }
}
