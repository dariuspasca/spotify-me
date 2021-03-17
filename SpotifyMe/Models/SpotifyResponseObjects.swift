//
//  SpotifyResponses.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 17/03/21.
//

import Foundation

// MARK: User
struct PrivateUser: Decodable {
    let displayName: String?
    let email: String
    let explicitContent: ExplicitContent
    let externalUrls: [String: String]
    let followers: Followers?
    let href: String
    // swiftlint:disable identifier_name
    let id: String
    let images: [Image]?
    let product: String
    let type: String
    let uri: String

    struct ExplicitContent: Decodable {
        let  filterEnabled: Bool?
        let  filterLocked: Bool?
    }

}

struct PublicUser: Decodable {
    let displayName: String
    let followers: Followers?
    let href: String
    let id: String
    let images: [Image]
    let type: String
    let uri: String
}

struct Followers: Decodable {
    let href: URL?
    let total: Int
}

struct ExternalUrl: Decodable {
    let spotify: String
}

// MARK: Playlist
struct Playlist: Decodable {
    let description: String?
    let id: String
    let images: [Image]?
    let name: String
    let `public`: Bool?
    let snapshotId: String
    let tracks: PlaylistTracksRef?
    let type: String
    let uri: URL
}

struct Paging: Decodable {
    let href: String
    let items: [Playlist]
    let limit: Int
    let next: URL?
    let offset: Int
    let previous: URL?
    let total: Int
}

struct PlaylistTracksRef: Decodable {
    let href: String
    let total: Int
}

// MARK: More

struct Image: Decodable {
    let height: Int?
    let url: String
    let width: Int?
}

struct AccessResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int

    let refreshToken: String?
}
