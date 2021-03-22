//
//  Paginated.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 22/03/21.
//

import Foundation

struct Paginated<T: Codable>: Codable {
    public let href: String
    public let items: [T]
    public let limit: Int
    public let offset: Int
    public let total: Int
    public let next: URL?
    public let previous: URL?
}
