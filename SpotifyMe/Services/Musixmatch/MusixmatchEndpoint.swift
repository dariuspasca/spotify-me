//
//  MusixmatchEndpoint.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 05/04/21.
//

import Foundation

enum MusixmatchEndpoint {
    case getLyrics
}

extension MusixmatchEndpoint {

    var url: URL {
        switch self {
        case .getLyrics:
            return URL(string: "https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?format=jsonp&callback=callback")!
        }
    }
}
