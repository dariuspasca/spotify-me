//
//  PlaylistTrack.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 22/03/21.
//

import Foundation

struct PlaylistTrack: Codable {
    let addedAt: Date?
    let isLocal: Bool
    let track: SimplifiedTrack? // some tracks might be unavailable due to market location
}
