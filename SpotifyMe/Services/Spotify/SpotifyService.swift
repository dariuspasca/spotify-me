//
//  SpotifyService.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 30/03/21.
//
// swiftlint:disable void_return

import Foundation
import os.log

class SpotifyService {

    static let shared = SpotifyService()

    var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true  // wait until the device is connected to the Internet
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }()

    private init() {}

}
// MARK: - Access Token

extension SpotifyService {

    func getAccessToken(completion: @escaping (Result<AccessAuthorization, Error>) -> ()) {
        var request = URLRequest(url: SpotifyEndpoint.tokenRequest.url)
        print(SpotifyAuthorizationConfig.clientAuthorizationKey())
        request.httpMethod = "POST"
        request.addValue(SpotifyAuthorizationConfig.clientAuthorizationKey(), forHTTPHeaderField:"Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        var bodyComponent = URLComponents()
        bodyComponent.queryItems = [URLQueryItem(name: "grant_type", value: "authorization_code"),
                                    URLQueryItem(name: "code", value: UserDefaults.standard.string(forKey: "authorizationCode")!),
                                    URLQueryItem(name: "redirect_uri", value: SpotifyAuthorizationConfig.redirectUri)]
        request.httpBody = bodyComponent.query?.data(using: .utf8)

        URLSession.shared.getResponse(for: request, responseType: AccessAuthorization.self) { (result) in
            completion(result)
        }
    }

    func updateAccessToken(refreshToken: String, completion: @escaping (Result<AccessAuthorization, Error>) -> ()) {
        var request = URLRequest(url: SpotifyEndpoint.tokenRequest.url)

        print(SpotifyAuthorizationConfig.clientAuthorizationKey())
        request.httpMethod = "POST"
        request.addValue(SpotifyAuthorizationConfig.clientAuthorizationKey(), forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")

        var bodyComponent = URLComponents()
        bodyComponent.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        request.httpBody = bodyComponent.query?.data(using: .utf8)

        URLSession.shared.getResponse(for: request, responseType: AccessAuthorization.self) { (result) in
            completion(result)
        }
    }
}

// MARK: - User

extension SpotifyService {

    func getUser(authorizationValue: String, completion: @escaping (Result<PrivateUser, Error>) -> Void) {
        var request = URLRequest(url: SpotifyEndpoint.userProfile.url)
        request.httpMethod = "GET"
        request.addValue(authorizationValue, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.getResponse(for: request, responseType: PrivateUser.self) { (result) in
            completion(result)
        }
    }
}

// MARK: - Playlists

extension SpotifyService {

    func getPlaylist(authorizationValue: String, fromUrl: URL, completion: @escaping (Result<SimplifiedPlaylist, Error>) -> Void) {
        var request = URLRequest(url: fromUrl)
        request.httpMethod = "GET"
        request.addValue(authorizationValue, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        URLSession.shared.getResponse(for: request, responseType: SimplifiedPlaylist.self) { (result) in
            completion(result)
        }
    }

    func getPlaylists(authorizationValue: String, fromUrl: URL, completion: @escaping (Result<Paginated<SimplifiedPlaylist>, Error>) -> Void) {
        var request = URLRequest(url: fromUrl)
        request.httpMethod = "GET"
        request.addValue(authorizationValue, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        URLSession.shared.getResponse(for: request, responseType: Paginated<SimplifiedPlaylist>.self) { (result) in
            completion(result)
        }
    }

    func getFeaturedPlaylists(authorizationValue: String, fromUrl: URL, completion: @escaping (Result<FeaturedPlaylists, Error>) -> Void) {
        var request = URLRequest(url: fromUrl)
        request.httpMethod = "GET"
        request.addValue(authorizationValue, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        URLSession.shared.getResponse(for: request, responseType: FeaturedPlaylists.self) { (result) in
            completion(result)
        }
    }

}

// MARK: - Tracks

extension SpotifyService {

    func getTracks(authorizationValue: String, playlist: String, offset: Int, completion: @escaping (Result<Paginated<PlaylistTrack>, Error>) -> ()) {
        var urlWithParams = URLComponents(string: SpotifyEndpoint.playlistTracks(playlist).url.absoluteString)!
        urlWithParams.queryItems = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "market", value: "US"),
            URLQueryItem(name: "additional_types", value: "track")
        ]
        var request = URLRequest(url: urlWithParams.url!)
        request.httpMethod = "GET"
        request.addValue(authorizationValue, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.getResponse(for: request, responseType: Paginated<PlaylistTrack>.self) { (result) in
            completion(result)
        }
    }
}

// MARK: - Albums

extension SpotifyService {

    func getNewReleases(authorizationValue: String, fromUrl: URL, completion: @escaping (Result<NewReleases, Error>) -> Void) {
        var request = URLRequest(url: fromUrl)
        request.httpMethod = "GET"
        request.addValue(authorizationValue, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        URLSession.shared.getResponse(for: request, responseType: NewReleases.self) { (result) in
            completion(result)
        }
    }

}
