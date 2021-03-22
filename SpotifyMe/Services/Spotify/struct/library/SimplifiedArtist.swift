//
//  TrackArtist.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 22/03/21.
//

import Foundation

struct SimplifiedArtist: Codable {
    let href: URL
    let id: String
    let name: String
    let type: String
    let uri: URL
}
