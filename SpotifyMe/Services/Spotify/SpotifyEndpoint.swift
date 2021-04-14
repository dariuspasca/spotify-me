//
//  SpotifyEndpoint.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 13/03/21.
//

import Foundation

enum SpotifyEndpoint {
    case userProfile
    case myPlalists
    case playlist(String)
    case playlistTracks(String)
    case featuredPlaylists
    case newReleases
    case tokenRequest
}

extension SpotifyEndpoint {

    var url: URL {
        switch self {
        case .userProfile:
            return URL(string: "https://api.spotify.com/v1/me")!
        case .myPlalists:
            return URL(string: "https://api.spotify.com/v1/me/playlists")!
        case .playlist(let id):
            return URL(string: "https://api.spotify.com/v1/playlists/\(id)")!
        case .playlistTracks(let id):
            return URL(string: "https://api.spotify.com/v1/playlists/\(id)/tracks")!
        case .featuredPlaylists:
            return URL(string: "https://api.spotify.com/v1/browse/featured-playlists")!
        case .newReleases:
            return URL(string: "https://api.spotify.com/v1/browse/new-releases")!
        case .tokenRequest:
            return URL(string: "https://accounts.spotify.com/api/token")!
        }
    }
}
