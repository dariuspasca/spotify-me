//
//  ServiceError.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 05/04/21.
//

import Foundation

enum ServiceError: Error {

    case badRequest
    case unauthorized
    case internalError(code: Int)

    public var description: String {
        switch self {
        case .badRequest:
            return "The request could not be understood by the server due to malformed syntax."
        case .unauthorized:
            return "The request authorization has been refused."
        case .internalError(let code):
            return "The quest failed with error code \(code)"
        }
    }
}
