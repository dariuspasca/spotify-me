//
//  Playlist.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 22/03/21.
//

import Foundation

struct SimplifiedPlaylist: Codable {
    let description: String?
    let id: String
    let images: [Image]?
    let name: String
    let `public`: Bool?
    let snapshotId: String
    let owner: PublicUser
    let tracks: TracksLink
    let type: String
    let uri: URL
}

extension SimplifiedPlaylist {

    struct TracksLink: Codable {
        public let href: URL
        public let total: Int
    }
}
