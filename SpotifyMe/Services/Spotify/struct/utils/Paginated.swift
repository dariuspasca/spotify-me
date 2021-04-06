//
//  Paginated.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 22/03/21.
//

import Foundation

struct Paginated<T: Codable>: Codable {
    let href: String
    let items: [T]
    let limit: Int
    let offset: Int
    let total: Int
    let next: URL?
    let previous: URL?
}
