//
//  SimplifiedTrack.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 22/03/21.
//

import Foundation

struct SimplifiedTrack: Codable {
    let durationMs: Int
    let artists: [SimplifiedArtist]
    let album: SimplifiedAlbum
    let href: URL
    let id: String
    let name: String
    let popularity: Int
    let uri: URL
}
