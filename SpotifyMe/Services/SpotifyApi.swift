//
//  SpotifyApi.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 11/03/21.
//

import Foundation

struct SpotifyApi {
    
    private let decoder = JSONDecoder()
    
    private let clientId = "e230fefaed454e198ceb79d4e21ef20c"
    private let clientSecret = "dcfb7885665c4ca6b8f3e05756598259"
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
                                    URLQueryItem(name: "code", value:UserDefaults.standard.string(forKey: "authorizationCode")!),
                                    URLQueryItem(name: "redirect_uri", value: redirectUri)]
        request.httpBody = bodyComponent.query?.data(using: .utf8)
        
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
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

    func requestRefreshAccessToken(refreshToken:String, completion: @escaping (Result<AccessResponse, Error>) -> ()) {
        
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
    
    func fetchSpotifyProfile(authorizationValue:String, completion: @escaping (Result<Profile, Error>) -> ()) {
        
        var request = URLRequest(url: SpotifyEndpoint.userProfile.url)
        request.httpMethod = "GET"
        
        
        // Header
        request.addValue(authorizationValue, forHTTPHeaderField:
                            "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")
        
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            do {
               // print(String(data: data!, encoding: String.Encoding.utf8))
                
                let profile = try decoder.decode(Profile.self, from: data!)
                completion(.success(profile))
            } catch {
                completion(.failure(error))
                return
            }
        }.resume()
    }
}

struct Profile:Decodable {
    let displayName: String?
    let email: String
    let explicitContent: ExplicitContent
    let externalUrls: [String:String]
    let followers: Followers?
    let href: String
    let id: String
    let images: [Images]?
    let product: String
    let type: String
    let uri: String
    
    struct ExplicitContent: Decodable {
        let  filterEnabled: Bool?
        let  filterLocked: Bool?
    }
    
    struct Followers: Decodable {
        let href:URL?
        let total:Int
    }
    
    struct Images: Decodable {
        let height:Int?
        let url:String?
        let width:Int?
    }
}


struct AccessResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    
    let refreshToken: String?
}
