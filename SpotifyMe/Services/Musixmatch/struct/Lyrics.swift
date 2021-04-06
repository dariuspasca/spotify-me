//
//  Lyrics.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 05/04/21.
//

import Foundation

struct Lyrics: Codable {
    let lyrics: LyricsBody

    struct LyricsBody: Codable {
        let lyricsId: Int
        let explicit: Int
        let lyricsBody: String
    }
}
