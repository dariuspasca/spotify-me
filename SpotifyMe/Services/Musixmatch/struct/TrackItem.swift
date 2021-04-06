//
//  TrackItem.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 05/04/21.
//

import Foundation

struct TrackItem: Codable {

    let track: Track

    struct Track: Codable {
        let trackId: Int
        let trackName: String
        let hasLyrics: Int

        let albumId: Int
        let albumName: String

        let artistId: Int
        let artistName: String

        let trackShareUrl: URL
    }
}
