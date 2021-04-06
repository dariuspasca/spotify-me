//
//  DownloadManager.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 29/03/21.
//

import Foundation
import os.log

class DownloadManager {

    private lazy var authorizationUrl = SpotifyAuthorizationConfig.authorizationRequestURL
    private var userSession: UserSession?
    private lazy var sessionManager = UserSessionManager()
    private lazy var userManager = UserProfileManager()
    private lazy var playlistManager = PlaylistManager()
    private lazy var tracktManager = TrackManager()
    private lazy var albumtManager = AlbumManager()
    private lazy var artistManager = ArtistManager()

    func loadUserSession() -> UserSession? {
        let authorizationCode = UserDefaults.standard.string(forKey: "authorizationCode")
        return sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode!)
    }
}

// MARK: - User

extension DownloadManager {

    func downloadProfile(completion: @escaping  (Result<Void, Error>) -> Void) {
        if userSession == nil {
            userSession = loadUserSession()
            guard userSession != nil else {
                completion(.failure(ServiceError.missingSession))
                return
            }
        }

        if userSession!.isExpired {
            SpotifyService.shared.updateAccessToken(refreshToken: userSession!.refreshToken!, completion: { (res) in
                switch res {
                case .success(let response):
                    self.userSession!.accessToken = response.accessToken
                    self.userSession!.expireAt = Date().addingTimeInterval(TimeInterval(response.expiresIn - 300))
                    self.sessionManager.updateUserSession(userSession: self.userSession!)
                    os_log("accessToken refreshed", type: .info)
                    self.downloadProfile(completion: completion)
                case .failure(let err):
                    os_log("Request to refresh accessToken failed with error: %@", type: .error, String(describing: err))
                    completion(.failure(err))
                }
            })
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
        if userSession == nil {
            userSession = loadUserSession()
            guard userSession != nil else {
                completion(.failure(ServiceError.missingSession))
                return
            }
        }

        if userSession!.isExpired {
            SpotifyService.shared.updateAccessToken(refreshToken: userSession!.refreshToken!, completion: { (res) in
                switch res {
                case .success(let response):
                    self.userSession!.accessToken = response.accessToken
                    self.userSession!.expireAt = Date().addingTimeInterval(TimeInterval(response.expiresIn - 300))
                    self.sessionManager.updateUserSession(userSession: self.userSession!)
                    os_log("accessToken refreshed", type: .info)
                    self.downloadPlaylists(url: url, completion: completion)
                case .failure(let err):
                    os_log("Request to refresh accessToken failed with error: %@", type: .error, String(describing: err))
                    completion(.success(()))
                }
            })
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
}

// MARK: - Tracks

extension DownloadManager {

    func downloadTracks(playlist: String, offset: Int = 0, completion: @escaping  ((Result<Void, Error>) -> Void)) {
        if userSession == nil {
            userSession = loadUserSession()
            guard userSession != nil else {
                completion(.failure(ServiceError.missingSession))
                return
            }
        }

        if userSession!.isExpired {
            SpotifyService.shared.updateAccessToken(refreshToken: userSession!.refreshToken!, completion: { (res) in
                switch res {
                case .success(let response):
                    self.userSession!.accessToken = response.accessToken
                    self.userSession!.expireAt = Date().addingTimeInterval(TimeInterval(response.expiresIn - 300))
                    self.sessionManager.updateUserSession(userSession: self.userSession!)
                    os_log("accessToken refreshed", type: .info)
                    self.downloadTracks(playlist: playlist, completion: completion)
                case .failure(let err):
                    os_log("Request to refresh accessToken failed with error: %@", type: .error, String(describing: err))
                    completion(.failure(err))
                }
            })
        } else {
            SpotifyService.shared.getTracks(authorizationValue: userSession!.authorizationValue, playlist: playlist, offset: offset) { (res) in
                switch res {
                case .success(let res):
                    let tracks = res.items
                    for trackItem in tracks {

                        // Create track, album and artist
                        self.tracktManager.createTrack(track: trackItem.track)
                        self.albumtManager.createAlbum(album: trackItem.track.album)
                        for artist in trackItem.track.artists {
                            self.artistManager.createArtist(artist: artist)
                        }

                        // Fetch created objects
                        let trackRef = self.tracktManager.fetchTrack(withId: trackItem.track.id)
                        let albumRef = self.albumtManager.fetchAlbum(withId: trackItem.track.album.id)
                        let playlistRef = self.playlistManager.fetchPlaylist(withId: playlist)
                        let artistsRef = self.artistManager.fetchArtists(withIds: trackItem.track.artists.map { ($0.id)})

                        // Add track relationships
                        if let newTrack = trackRef, let newAlbum = albumRef, let newPlaylist = playlistRef, let newArtists = artistsRef {
                            newTrack.addToPlaylists(newPlaylist)
                            newTrack.addToAlbums(newAlbum)
                            newTrack.addToArtists(NSSet.init(array: newArtists))
                            self.tracktManager.updateTrack(track: newTrack)
                        }
                    }

                    if res.next != nil {
                        let newOffset = res.offset + 100
                        self.downloadTracks(playlist: playlist, offset: newOffset, completion: completion)
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
}

// MARK: - Lyrics

extension DownloadManager {

    func getMusixmatchTrack(track: Track, completion: @escaping (TrackItem?) -> Void) {
        var artists: String?

        if let trackArtists = track.artists?.allObjects as? [Artist] {
            artists = trackArtists.map { ($0.name!)}.joined(separator: " ")
        }

        MusixmatchService.shared.getTrack(name: track.name!, artist: artists ?? "") { (result) in
            completion(result)
        }
    }

    func getMusixmatchLyrics(trackId: Int, completion: @escaping (String?) -> Void) {
        MusixmatchService.shared.getLyrics(trackId: trackId) { (lyrics) in
            guard lyrics != nil else { return }
            completion(lyrics)
        }
    }
}
