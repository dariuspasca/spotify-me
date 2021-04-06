//
//  ResponseBody.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 05/04/21.
//

import Foundation

struct ResponseBody<T: Codable>: Codable {
    let message: MessageBody<T>

    struct MessageBody<T: Codable>: Codable {
        let body: T
        
    }
}
