//
//  FeaturedPlaylists.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 14/04/21.
//

import Foundation

struct FeaturedPlaylists: Codable {
    let message: String
    let playlists: Paginated<SimplifiedPlaylist>
}
