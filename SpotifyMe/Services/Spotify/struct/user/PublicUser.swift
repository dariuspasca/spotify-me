//
//  PublicUser.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 27/03/21.
//

import Foundation

struct PublicUser: Codable {
    let displayName: String?
    let followers: Followers?
    let href: URL
    let id: String
    let images: [Image]?
    let type: String
    let uri: String
}
