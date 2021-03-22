//
//  PrivateUser.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 22/03/21.
//

import Foundation

struct PrivateUser: Codable {
    let displayName: String?
    let email: String
    let followers: Followers?
    let href: URL
    let id: String
    let images: [Image]?
    let product: String
    let type: String
    let uri: String
}
