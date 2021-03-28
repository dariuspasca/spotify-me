//
//  PlaylistViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 28/03/21.
//

import UIKit
import os.log

class PlaylistViewController: UIViewController {

    var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    let spotifyApi = SpotifyApi.init()
    let sessionManager = UserSessionManager()
    var tracks = [PlaylistTrack]()
    var userSession: UserSession?
    var playlist:SimplifiedPlaylist!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        self.title = playlist.name

        let authorizationCode = UserDefaults.standard.string(forKey: "authorizationCode")
        userSession = sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode!)

        loadTracks { (tracks) in
            self.tracks = tracks!.items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        configureTableView()
    }

    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 80
        tableView.register(TrackViewCell.self, forCellReuseIdentifier: "TrackCell")
        tableView.register(PlaylistHeaderView.self, forHeaderFooterViewReuseIdentifier: "PlaylistHeader")
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear
        tableView.pin(to: view)
    }

    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Table Data

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as? TrackViewCell
        cell!.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        cell!.set(track: tracks[indexPath.row].track)
        return cell!
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PlaylistHeader") as? PlaylistHeaderView
        header!.set(playlist: playlist)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
}

// MARK: - Fetching Data

extension PlaylistViewController {

    func loadTracks(completion: @escaping (Paginated<PlaylistTrack>?) -> Void) {
        guard userSession != nil else { return }
        // Check if access token is valid or has to be refreshed
        if userSession!.isExpired {
            refreshToken { (res) in
                if res {
                    self.loadTracks(completion: completion)
                }
            }
        } else {
            fetchTracks { (res) in
                completion(res)
            }
        }

    }

    func fetchTracks(completion: @escaping (Paginated<PlaylistTrack>?) -> Void) {
        let playlistTracksUrl = SpotifyEndpoint.playlistTracks(playlist.id).url
        spotifyApi.fetchTracks(authorizationValue: userSession!.authorizationValue, withUrl: playlistTracksUrl) { (res) in
            switch res {
            case .success(let response):
                completion(response)
                os_log("Fetching playlist tracks", type: .info)
            case .failure(let err):
                completion(nil)
                os_log("API request to get playlist tracks failed with error: %@", type: .error, String(describing: err))
            }
        }
        return
    }

    func refreshToken(completion: @escaping (Bool) -> Void) {
        spotifyApi.requestRefreshAccessToken(refreshToken: userSession!.refreshToken!) { (res) in
            switch res {
            case .success(let response):
                DispatchQueue.main.async {
                    self.userSession!.accessToken = response.accessToken
                    self.userSession!.expireAt = Date().addingTimeInterval(TimeInterval(response.expiresIn - 300))
                    self.sessionManager.updateUserSession(userSession: self.userSession!)
                    completion(true)
                    os_log("accessToken refreshed", type: .info)
                }
            case .failure(let err):
                completion(false)
                os_log("Request to refresh accessToken failed with error: %@", type: .error, String(describing: err))
            }
        }
    }
}
