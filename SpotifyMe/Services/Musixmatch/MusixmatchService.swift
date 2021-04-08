//
//  MusixmatchService.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 05/04/21.
//

import Foundation
import os.log

class MusixmatchService {

    static let shared = MusixmatchService()
    static let apiKey = ProcessInfo.processInfo.environment["musixmatch_api"]!

    var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true  // wait until the device is connected to the Internet
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }()

    private init() {}
}

// MARK: - Lyrics

extension MusixmatchService {

    func getLyrics(name: String, artist: String, completion: @escaping (String?) -> Void) {
        var urlWithParams = URLComponents(string: MusixmatchEndpoint.getLyrics.url.absoluteString)!
        urlWithParams.queryItems = [
            URLQueryItem(name: "q_track", value: name),
            URLQueryItem(name: "q_artist", value: artist),
            URLQueryItem(name: "apikey", value: MusixmatchService.apiKey)
        ]
        var request = URLRequest(url: urlWithParams.url!)

        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.getResponse(for: request, responseType: ResponseBody<Lyrics>.self) { (result) in
            switch result {
            case .success(let response):
                completion(response.message.body.lyrics.lyricsBody)
            case .failure:
                // Not found
                completion(nil)
            }
        }
    }

}
