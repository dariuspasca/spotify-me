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

        // Popular artists are fetched from the playlist tracks, thus the populateArtists function is called after playlist tracks are downloaded
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveGlobalTopTracks(notification:)), name: .didDownloadGlobalTopTracks, object: nil)

        getTopTracks()
        getFeaturedPlaylists()
        getNewReleases()
    }

    @objc func didReceiveGlobalTopTracks(notification: NSNotification) {
        guard notification.object == nil else { return }
        getPopularArtists()
    }
}

extension HomeViewModel {

    private func getTopTracks() {
        let playlist = playlistManager.fetchPlaylist(withId: playlistId)
        if playlist?.tracks == nil {
            downloadTopTracks()
        } else {
            NotificationCenter.default.post(name: .didDownloadGlobalTopTracks, object: nil)
        }
    }

    private func downloadTopTracks() {
        DownloadManager.shared.downloadPlaylist(url: SpotifyEndpoint.playlist(playlistId).url) { res in
            switch res {
            case .success:
                DownloadManager.shared.downloadTracks(playlist: self.playlistId) { (res) in
                    switch res {
                    case .success:
                        NotificationCenter.default.post(name: .didDownloadGlobalTopTracks, object: nil)
                    case .failure(let err):
                        NotificationCenter.default.post(name: .didDownloadGlobalTopTracks, object: err)
                    }
                }
            case .failure(let err):
                NotificationCenter.default.post(name: .didDownloadGlobalTopTracks, object: err)
            }
        }
    }

    private func getFeaturedPlaylists() {
        if playlistManager.fetchPlaylists(withType: "featured")!.isEmpty {
            downloadFeaturedPlaylists()
        } else {
            NotificationCenter.default.post(name: .didDownloadFeaturedPlaylists, object: nil)
        }
    }

    private func downloadFeaturedPlaylists() {
        DownloadManager.shared.downloadFeaturedPlaylists(url: SpotifyEndpoint.featuredPlaylists.url) { (res) in
            switch res {
            case .success:
                NotificationCenter.default.post(name: .didDownloadFeaturedPlaylists, object: nil)
            case .failure(let err):
                NotificationCenter.default.post(name: .didDownloadFeaturedPlaylists, object: err)
            }
        }
    }

    private func getNewReleases() {
        if albumManager.fetchAlbums(withType: "newReleases")!.isEmpty {
            downloadNewReleases()
        } else {
            NotificationCenter.default.post(name: .didDownloadNewAlbumReleases, object: nil)
        }
    }

    private func downloadNewReleases() {
        DownloadManager.shared.downloadNewReleases(url: SpotifyEndpoint.newReleases.url) { (res) in
            switch res {
            case .success:
                NotificationCenter.default.post(name: .didDownloadNewAlbumReleases, object: nil)
            case .failure(let err):
                NotificationCenter.default.post(name: .didDownloadNewAlbumReleases, object: err)
            }
        }
    }

    private func getPopularArtists() {
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

        if artistManager.fetchArtists(withIds: artistsList)!.isEmpty {
            populatePopularArtists(artists: artistsList)
        } else {
            NotificationCenter.default.post(name: .didDownloadPopularArtists, object: artistsList)
        }

    }

    private func populatePopularArtists(artists: [String]) {
        DownloadManager.shared.downloadArtists(artists: artists) { (res) in
            switch res {
            case .success:
                NotificationCenter.default.post(name: .didDownloadPopularArtists, object: artists)
            case .failure(let err):
                NotificationCenter.default.post(name: .didDownloadPopularArtists, object: err)
            }
        }
    }
}
