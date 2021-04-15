//
//  DownloadManager.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 29/03/21.
//

import Foundation
import os.log

class DownloadManager {

    static let shared = DownloadManager()

    private lazy var authorizationUrl = SpotifyAuthorizationConfig.authorizationRequestURL
    private var userSession: UserSession?

    private lazy var sessionManager = UserSessionManager()
    private lazy var userManager = UserProfileManager()
    private lazy var playlistManager = PlaylistManager()
    private lazy var tracktManager = TrackManager()
    private lazy var albumtManager = AlbumManager()
    private lazy var artistManager = ArtistManager()

    private init() {
        let authorizationCode = UserDefaults.standard.string(forKey: "authorizationCode")
        userSession = sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode!)
    }

    private func refreshAccessToken(completion: @escaping  (Result<Void, Error>) -> Void) {
        SpotifyService.shared.updateAccessToken(refreshToken: userSession!.refreshToken!, completion: { (res) in
            switch res {
            case .success(let response):
                self.userSession!.accessToken = response.accessToken
                self.userSession!.expireAt = Date().addingTimeInterval(TimeInterval(response.expiresIn - 300))
                self.sessionManager.updateUserSession(userSession: self.userSession!)
                completion(.success(()))
            case .failure(let err):
                os_log("Request to refresh accessToken failed with error: %@", type: .error, String(describing: err))
                completion(.failure(err))
            }
        })
    }
}

// MARK: - User

extension DownloadManager {

    func downloadProfile(completion: @escaping  (Result<Void, Error>) -> Void) {
        guard userSession != nil else {
            completion(.failure(ServiceError.missingSession))
            return
        }

        if userSession!.isExpired {
            refreshAccessToken { (res) in
                switch res {
                case .success:
                    self.downloadProfile(completion: completion)
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        } else {
            SpotifyService.shared.getUser(authorizationValue: userSession!.authorizationValue) { (res) in
                switch res {
                case .success(let response):
                    self.userManager.createUserProfile(userObj: response, sessionId: self.userSession!.objectID)
                    completion(.success(()))
                    os_log("User profile created", type: .info)
                case .failure(let err):
                    os_log("Request to get and create user profile failed with error: %@", type: .error, String(describing: err))
                    completion(.failure(err))
                }
            }

        }

    }
}

// MARK: - Playlist

extension DownloadManager {

    func downloadPlaylists(url: URL, completion: @escaping  ((Result<Void, Error>) -> Void)) {
        guard userSession != nil else {
            completion(.failure(ServiceError.missingSession))
            return
        }

        if userSession!.isExpired {
            refreshAccessToken { (res) in
                switch res {
                case .success:
                    self.downloadPlaylists(url: url, completion: completion)
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        } else {
            SpotifyService.shared.getPlaylists(authorizationValue: userSession!.authorizationValue, fromUrl: url) { (res) in
                switch res {
                case .success(let res):
                    let playlists = res.items
                    for playlist in playlists {
                        self.playlistManager.createPlaylist(playlist: playlist, userProfileId: self.userSession!.profile?.objectID)
                    }

                    if let next = res.next {
                        self.downloadPlaylists(url: next, completion: completion)
                    } else {
                        completion(.success(()))
                    }
                case .failure(let err):
                    os_log("Failed to download playlists with error: %@", type: .error, String(describing: err))
                    completion(.failure(err))
                }
            }
        }
    }

    func downloadPlaylist(url: URL, completion: @escaping  ((Result<Void, Error>) -> Void)) {
        guard userSession != nil else {
            completion(.failure(ServiceError.missingSession))
            return
        }

        if userSession!.isExpired {
            refreshAccessToken { (res) in
                switch res {
                case .success:
                    self.downloadPlaylist(url: url, completion: completion)
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        } else {
            SpotifyService.shared.getPlaylist(authorizationValue: userSession!.authorizationValue, fromUrl: url) { (res) in
                switch res {
                case .success(let playlist):
                    self.playlistManager.createPlaylist(playlist: playlist, userProfileId: self.userSession!.profile?.objectID)
                    completion(.success(()))
                case .failure(let err):
                    os_log("Failed to download playlist with error: %@", type: .error, String(describing: err))
                    completion(.failure(err))
                }
            }
        }
    }

    func downloadFeaturedPlaylists(url: URL, completion: @escaping  ((Result<Void, Error>) -> Void)) {
        guard userSession != nil else {
            completion(.failure(ServiceError.missingSession))
            return
        }

        if userSession!.isExpired {
            refreshAccessToken { (res) in
                switch res {
                case .success:
                    self.downloadFeaturedPlaylists(url: url, completion: completion)
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        } else {
            SpotifyService.shared.getFeaturedPlaylists(authorizationValue: userSession!.authorizationValue, fromUrl: url) { (res) in
                switch res {
                case .success(let res):
                    for playlist in res.playlists.items {
                        self.playlistManager.createPlaylist(playlist: playlist, type: "featured", userProfileId: self.userSession!.profile?.objectID)
                    }
                    completion(.success(()))
                case .failure(let err):
                    os_log("Failed to download featured playlist with error: %@", type: .error, String(describing: err))
                    completion(.failure(err))
                }
            }
        }
    }

}

// MARK: - Tracks

extension DownloadManager {

    func downloadTracks(playlist: String, offset: Int = 0, completion: @escaping  ((Result<Void, Error>) -> Void)) {
        guard userSession != nil else {
            completion(.failure(ServiceError.missingSession))
            return
        }

        if userSession!.isExpired {
            refreshAccessToken { (res) in
                switch res {
                case .success:
                    self.downloadTracks(playlist: playlist, completion: completion)
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        } else {
            SpotifyService.shared.getTracks(authorizationValue: userSession!.authorizationValue, playlist: playlist, offset: offset) { (res) in
                switch res {
                case .success(let res):
                    let tracks = res.items
                    for trackItem in tracks {
                        if let trackObj = trackItem.track {
                            self.createNewTrack(track: trackObj, playlistId: playlist)
                        }
                    }

                    if res.next != nil {
                        let newOffset = res.offset + 100
                        self.downloadTracks(playlist: playlist, offset: newOffset, completion: completion)
                    } else {
                        completion(.success(()))
                    }
                case .failure(let err):
                    os_log("Failed to download tracks with error: %@", type: .error, String(describing: err))
                    completion(.failure(err))
                }
            }
        }
    }

    func createNewTrack(track: SimplifiedTrack, playlistId: String) {
        // Track already exists
        guard self.tracktManager.fetchTrack(withId: track.id) == nil else { return }

        // Create track
        self.tracktManager.createTrack(track: track)
        let trackRef = self.tracktManager.fetchTrack(withId: track.id)

        // Album
        var albumRef = self.albumtManager.fetchAlbum(withId: track.album.id)

        if albumRef == nil {
            self.albumtManager.createAlbum(album: track.album)
            albumRef = self.albumtManager.fetchAlbum(withId: track.album.id)
        }
        trackRef!.addToAlbums(albumRef!)

        // Artists
        for artist in track.artists {
            if self.artistManager.fetchArtist(withId: artist.id) == nil {
                self.artistManager.createArtist(artist: artist)
            }
        }
        let artistsRef = self.artistManager.fetchArtists(withIds: track.artists.map { ($0.id)})
        trackRef!.addToArtists(NSSet.init(array: artistsRef!))
        // Playlist
        let playlistRef = self.playlistManager.fetchPlaylist(withId: playlistId)
        trackRef?.addToPlaylists(playlistRef!)

        self.tracktManager.updateTrack(track: trackRef!)
    }
}

// MARK: - Albums

extension DownloadManager {

    func downloadNewReleases(url: URL, completion: @escaping  ((Result<Void, Error>) -> Void)) {
        guard userSession != nil else {
            completion(.failure(ServiceError.missingSession))
            return
        }

        if userSession!.isExpired {
            refreshAccessToken { (res) in
                switch res {
                case .success:
                    self.downloadNewReleases(url: url, completion: completion)
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        } else {
            SpotifyService.shared.getNewReleases(authorizationValue: userSession!.authorizationValue, fromUrl: url) { (res) in
                switch res {
                case .success(let res):
                    for album in res.albums.items {
                        self.albumtManager.createAlbum(album: album, type: "newReleases")
                        let albumRef = self.albumtManager.fetchAlbum(withId: album.id)

                        for artist in album.artists {
                            if self.artistManager.fetchArtist(withId: artist.id) == nil {
                                self.artistManager.createArtist(artist: artist)
                            }
                        }
                        let artistsRef = self.artistManager.fetchArtists(withIds: album.artists.map { ($0.id)})
                        albumRef!.addToArtists(NSSet.init(array: artistsRef!))
                    }
                    completion(.success(()))
                case .failure(let err):
                    os_log("Failed to download new releases with error: %@", type: .error, String(describing: err))
                    completion(.failure(err))
                }
            }
        }
    }

}

// MARK: - Artists

extension DownloadManager {

    func downloadArtist(url: URL, completion: @escaping  ((Result<Void, Error>) -> Void)) {
        guard userSession != nil else {
            completion(.failure(ServiceError.missingSession))
            return
        }

        if userSession!.isExpired {
            refreshAccessToken { (res) in
                switch res {
                case .success:
                    self.downloadArtist(url: url, completion: completion)
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        } else {
            SpotifyService.shared.getArtist(authorizationValue: userSession!.authorizationValue, fromUrl: url) { (res) in
                switch res {
                case .success(let artist):
                    self.upsertArtist(newArtist: artist)
                    completion(.success(()))
                case .failure(let err):
                    os_log("Failed to download artist with error: %@", type: .error, String(describing: err))
                    completion(.failure(err))
                }
            }
        }
    }

    func downloadArtists(artists: [String], completion: @escaping  ((Result<Void, Error>) -> Void)) {
        guard userSession != nil else {
            completion(.failure(ServiceError.missingSession))
            return
        }

        if userSession!.isExpired {
            refreshAccessToken { (res) in
                switch res {
                case .success:
                    self.downloadArtists(artists: artists, completion: completion)
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        } else {
            var maxRange: Int = 50
            if artists.count < 50 { maxRange = artists.count }
            let artistsId = artists[..<maxRange].map { $0 }.joined(separator: ",")
            SpotifyService.shared.getArtists(authorizationValue: userSession!.authorizationValue, artists: artistsId) { (res) in
                switch res {
                case .success(let res):
                    res.artists.forEach { (artist) in
                        self.upsertArtist(newArtist: artist)
                    }

                    if maxRange > 50 {
                        let remainingArtists = artists[maxRange...].map { $0 }
                        self.downloadArtists(artists: remainingArtists, completion: completion)
                    } else {
                        completion(.success(()))
                    }
                case .failure(let err):
                    os_log("Failed to download artists with error: %@", type: .error, String(describing: err))
                    completion(.failure(err))
                }
            }
        }
    }

    func upsertArtist(newArtist: SimplifiedArtist) {
        if let artist = self.artistManager.fetchArtist(withId: newArtist.id) {
            artist.name = newArtist.name
            artist.popularity = Int16(newArtist.popularity!)
            artist.href = newArtist.href

            if let coverImage = newArtist.images {
                artist.coverImage = coverImage[0].url
            }

            self.artistManager.updateArtist(artist: artist)
        } else {
            self.artistManager.createArtist(artist: newArtist)
        }
    }
}
