//
//  SpotifyApi.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 11/03/21.
//

import Foundation
import Combine

struct SpotifyApi {

    private let decoder = JSONDecoder()

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

    // swiftlint:disable:next void_return
    func requestAccessAndRefreshToken(completion: @escaping (Result<AccessResponse, Error>) -> ()) {

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

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        // swiftlint:disable:next unused_closure_parameter
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            do {
                let accessTokens = try decoder.decode(AccessResponse.self, from: data!)
                completion(.success(accessTokens))
            } catch {
                completion(.failure(error))
                return
            }
        }.resume()
    }

    // swiftlint:disable:next void_return
    func requestRefreshAccessToken(refreshToken: String, completion: @escaping (Result<AccessResponse, Error>) -> ()) {

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
        bodyComponent.queryItems = [URLQueryItem(name: "grant_type", value: "refresh_token"),
                                    URLQueryItem(name: "refresh_token", value: refreshToken)]
        request.httpBody = bodyComponent.query?.data(using: .utf8)

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        // swiftlint:disable:next unused_closure_parameter
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            do {
                let refreshToken = try decoder.decode(AccessResponse.self, from: data!)
                completion(.success(refreshToken))
            } catch {
                completion(.failure(error))
                return
            }
        }.resume()
    }

    // swiftlint:disable:next void_return
    func fetchProfile(authorizationValue: String, completion: @escaping (Result<PrivateUser, Error>) -> ()) {

        var request = URLRequest(url: SpotifyEndpoint.userProfile.url)
        request.httpMethod = "GET"

        // Header
        request.addValue(authorizationValue, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        // swiftlint:disable:next unused_closure_parameter
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            do {
                // print(String(data: data!, encoding: String.Encoding.utf8))

                let profile = try decoder.decode(PrivateUser.self, from: data!)
                completion(.success(profile))
            } catch {
                completion(.failure(error))
                return
            }
        }.resume()
    }

    // swiftlint:disable:next void_return
    func fetchPlaylists(authorizationValue: String, completion: @escaping (Result<Paging, Error>) -> ()) {

        var request = URLRequest(url: SpotifyEndpoint.myPlaylists.url)
        request.httpMethod = "GET"

        // Header
        request.addValue(authorizationValue, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        // swiftlint:disable:next unused_closure_parameter
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            do {
                // print(String(data: data!, encoding: String.Encoding.utf8))

                let playlists = try decoder.decode(Paging.self, from: data!)
                completion(.success(playlists))
            } catch {
                completion(.failure(error))
                return
            }
        }.resume()
    }

    func testPlaylist(authorizationValue: String, withUrl: URL) {
        var cancellable: AnyCancellable?
        var request = URLRequest(url: withUrl)
        request.httpMethod = "GET"

        // Header
        request.addValue(authorizationValue, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        cancellable = URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: Paging.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            },
            receiveValue: { playlist
                in print("Received user: \(playlist).")})
    }
}
