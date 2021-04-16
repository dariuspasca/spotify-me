//
//  Notifications+Names.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 16/04/21.
//

import Foundation

extension Notification.Name {
    // Home
    static let didDownloadGlobalTopTracks = Notification.Name("didDownloadGlobalTopTracks")
    static let didDownloadNewAlbumReleases = Notification.Name("didDownloadNewAlbumReleases")
    static let didDownloadFeaturedPlaylists = Notification.Name("didDownloadFeaturedPlaylists")
    static let didDownloadPopularArtists = Notification.Name("didDownloadPopularArtists")
    // Library
    static let didDownloadPrivatePlaylists = Notification.Name("didDownloadPrivatePlaylist")
}
