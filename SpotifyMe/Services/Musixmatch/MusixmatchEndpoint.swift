//
//  MusixmatchEndpoint.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 05/04/21.
//

import Foundation

enum MusixmatchEndpoint {
    case matcherGetTrack
    case getLyrics
}

extension MusixmatchEndpoint {

    var url: URL {
        switch self {
        case .matcherGetTrack:
            return URL(string: "https://api.musixmatch.com/ws/1.1/matcher.track.get?format=jsonp&callback=callback")!
        case .getLyrics:
            return URL(string: "https://api.musixmatch.com/ws/1.1/track.lyrics.get?format=jsonp&callback=callback")!
        }
    }
}
