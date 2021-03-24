//
//  ViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 11/03/21.
//

import UIKit
import os.log

class ViewController: UIViewController {

    let spotifyApi = SpotifyApi.init()
    let sessionManager = UserSessionManager()
    let profileManager = UserProfileManager()
    let playlistManager = PlaylistManager()
    let trackManager = TrackManager()
    var auth: String!
    var userSession: UserSession?
    @IBOutlet weak var connectToSpotify: UIButton!
    @IBOutlet weak var populateData: UIButton!

    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Buttons
    @IBAction func connect(_ sender: Any) {
        let connectString = SpotifyApi.init().authorizationRequestURL()
        UIApplication.shared.open(connectString)
    }

    @IBAction func populateSpotify(_ sender: Any) {
        let authorizationCode = UserDefaults.standard.string(forKey: "authorizationCode")

        userSession = sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode!)
        guard userSession != nil else {
            return
        }

        var userProfile:PrivateUser?
        var userPlaylists: [SimplifiedPlaylist]?
        var playlistsTracks: [[String:[PlaylistTrack]]] = []

        auth = userSession!.authorizationValue

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        fetchProfile {(profile) in
            userProfile = profile
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchPlaylists {(playlists) in
            userPlaylists = playlists
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchPlaylists {(playlists) in
            userPlaylists = playlists
            dispatchGroup.leave()
        }

        dispatchGroup.wait()

        dispatchGroup.enter()
        for playlist in userPlaylists! {
            if (playlist.tracks.total > 400 ) {
                print("Playlist \(playlist.name) with \(playlist.tracks.total) tracks")
                fetchTracks(fromUrl: playlist.tracks.href) { (res) in
                    print(res)
                }


            }
        }
        dispatchGroup.leave()

        dispatchGroup.notify(queue: .main) {
            print(playlistsTracks)
            if userProfile != nil {
                self.profileManager.createUserProfile(userObj: userProfile!, sessionId: self.userSession!.objectID)
            }

            if userPlaylists != nil {
                for playlist in userPlaylists! {
                   // self.playlistManager.createPlaylist(playlistObj: playlist, userProfileId: self.userSession!.profile!.objectID)
                }
            }
        }

    }

    // MARK: - Actions

    func fetchProfile(completion: @escaping (PrivateUser?) -> Void) {
        os_log("Fetching user profile", type: .info)
        spotifyApi.fetchProfile(authorizationValue: userSession!.authorizationValue) { (res) in
            switch res {
            case .success(let response):
                completion(response)
            case .failure(let err):
                completion(nil)
                os_log("API request to get UserProfile failed with error: %@", type: .error, String(describing: err))
            }
        }
        return

    }

    func fetchPlaylists(completion: @escaping ([SimplifiedPlaylist]?) -> Void) {
        os_log("Fetching user playlists", type: .info)
        spotifyApi.fetchPlaylists(authorizationValue: userSession!.authorizationValue) { (res) in
            switch res {
            case .success(let response):
                let playlists = response.items
                completion(playlists)
            case .failure(let err):
                completion(nil)
                os_log("API request to get user playlists failed with error: %@", type: .error, String(describing: err))
            }
        }
        return
    }

    func fetchTracks(fromUrl url:URL, completion: @escaping (Paginated<PlaylistTrack>?) -> Void) {
            self.spotifyApi.fetchTracks(authorizationValue: auth, withUrl: url ) { (res) in
                switch res {
                case .success(let response):
                        completion(response)
                case .failure(let err):
                    completion(nil)
                    os_log("API request to get UserProfile failed with error: %@", type: .error, String(describing: err))
                }
            }
        }

}
