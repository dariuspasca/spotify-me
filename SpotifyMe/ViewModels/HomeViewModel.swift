//
//  HomeViewModel.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 16/04/21.
//

import Foundation

class HomeViewModel: NSObject {

    private var playlistId: String!

    private var playlistManager = PlaylistManager()
    private var albumManager = AlbumManager()
    private var artistManager = ArtistManager()

    init(playlist: String) {
        super.init()
        playlistId = playlist
        loadData()
    }

    private func loadData() {
        let dispatchGroup = DispatchGroup()

        // Weekly Top Tracks Table
        dispatchGroup.enter()
        populateTopTracks { (res) in
            dispatchGroup.enter()
            switch res {
            case .success:
                NotificationCenter.default.post(name: .didDownloadGlobalTopTracks, object: nil)
                dispatchGroup.leave()
            case .failure(let err):
                NotificationCenter.default.post(name: .didDownloadGlobalTopTracks, object: err)
                dispatchGroup.leave()
            }
            dispatchGroup.leave()
        }

        // Featured Playlists Collection
        dispatchGroup.enter()
        populateFeaturedPlaylists { (res) in
            dispatchGroup.enter()
            switch res {
            case .success:
                NotificationCenter.default.post(name: .didDownloadFeaturedPlaylists, object: nil)
                dispatchGroup.leave()
            case .failure(let err):
                NotificationCenter.default.post(name: .didDownloadFeaturedPlaylists, object: err)
                dispatchGroup.leave()
            }
            dispatchGroup.leave()
        }

        // New Releases Collection
        dispatchGroup.enter()
        populateNewReleases { (res) in
            dispatchGroup.enter()
            switch res {
            case .success:
                NotificationCenter.default.post(name: .didDownloadNewAlbumReleases, object: nil)
                dispatchGroup.leave()
            case .failure(let err):
                NotificationCenter.default.post(name: .didDownloadNewAlbumReleases, object: err)
                dispatchGroup.leave()
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            // Popular Artists Collection
            self.populatePopularArtists { (res) in
                switch res {
                case .success(let artists):
                    NotificationCenter.default.post(name: .didDownloadPopularArtists, object: artists)
                case .failure(let err):
                    NotificationCenter.default.post(name: .didDownloadPopularArtists, object: err)
                }
            }
        }
    }
}

extension HomeViewModel {

    private func populateTopTracks(completion: @escaping  ((Result<Void, Error>) -> Void)) {
        DownloadManager.shared.downloadPlaylist(url: SpotifyEndpoint.playlist(playlistId).url) { res in
            switch res {
            case .success:
                DownloadManager.shared.downloadTracks(playlist: self.playlistId) { (res) in
                    switch res {
                    case .success:
                        NotificationCenter.default.post(name: .didDownloadGlobalTopTracks, object: nil)
                    case .failure(let err):
                        completion(.failure(err))
                    }
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    func populateFeaturedPlaylists(completion: @escaping  ((Result<Void, Error>) -> Void)) {
        DownloadManager.shared.downloadFeaturedPlaylists(url: SpotifyEndpoint.featuredPlaylists.url) { (res) in
            switch res {
            case .success:
                completion(.success(()))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    func populateNewReleases(completion: @escaping  ((Result<Void, Error>) -> Void)) {
        DownloadManager.shared.downloadNewReleases(url: SpotifyEndpoint.newReleases.url) { (res) in
            switch res {
            case .success:
                completion(.success(()))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    func populatePopularArtists(completion: @escaping  ((Result<[String], Error>) -> Void)) {
        var artists: Set<String> = []
        let playlist = self.playlistManager.fetchPlaylist(withId: self.playlistId)
        let tracks = playlist!.tracks?.allObjects as? [Track]

        for track in tracks! {
            if let trackArtists = track.artists?.allObjects as? [Artist] {
                let artistsIds = trackArtists.map { ($0.id)}
                artistsIds.forEach { (artistId) in
                    artists.insert(artistId!)
                }
            }
        }
        let artistsList = artists.map { ($0) }
        DownloadManager.shared.downloadArtists(artists: artistsList) { (res) in
            switch res {
            case .success:
                completion(.success(artists.map { $0 }))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
