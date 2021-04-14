//
//  NewReleases.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 14/04/21.
//

import Foundation

struct NewReleases: Codable {
    let albums: Paginated<SimplifiedAlbum>
}
