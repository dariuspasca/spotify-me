//
//  SimplifiedAlbum.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 22/03/21.
//

import Foundation

struct SimplifiedAlbum: Codable {
    let albumType: String
    let artists: [SimplifiedArtist]
    let href: URL
    let id: String
    let images: [Image]
    let name: String?
    let releaseDate: String
    let type: String
    let uri: URL
}
