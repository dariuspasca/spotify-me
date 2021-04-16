//
//  LibraryViewModel.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 16/04/21.
//

import Foundation

class LibraryViewModel: NSObject {

    private let sessionManager = UserSessionManager()

    override init() {
        super.init()

        // Setup notification
        NotificationCenter.default.post(name: .didDownloadPrivatePlaylists, object: nil)

        loadPrivatePlaylists()
    }
}

extension LibraryViewModel {

    func loadPrivatePlaylists() {
        DownloadManager.shared.downloadPlaylists(url: SpotifyEndpoint.myPlalists.url) { (result) in
            switch result {
            case .success:
                NotificationCenter.default.post(name: .didDownloadPrivatePlaylists, object: nil)
            case .failure(let err):
                NotificationCenter.default.post(name: .didDownloadPrivatePlaylists, object: err)
            }

        }
    }
}
