//
//  RefreshTokenResponse.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 22/03/21.
//

import Foundation

struct RefreshTokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int

    let refreshToken: String?
}
