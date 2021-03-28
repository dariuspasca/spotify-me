//
//  PlaylistListViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 26/03/21.
//

import UIKit
import os.log

class PlaylistListViewController: UIViewController {

    var tableView = UITableView()
    let spotifyApi = SpotifyApi.init()
    let sessionManager = UserSessionManager()
    var playlists = [SimplifiedPlaylist]()
    var userSession: UserSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Playlists"

        let authorizationCode = UserDefaults.standard.string(forKey: "authorizationCode")
        userSession = sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode!)

        loadPlaylists { (playlists) in
            self.playlists = playlists!.items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        configureTableView()
    }

    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.register(PlaylistViewCell.self, forCellReuseIdentifier: "PlaylistCell")
        tableView.pin(to: view)
    }

    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Table Data

extension PlaylistListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell") as? PlaylistViewCell
        cell!.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        cell!.accessoryType = .disclosureIndicator

       //  cell!.accessoryView = UIImageView(image: #imageLiteral(resourceName: "chevron-right"))
        let chevronIcon = UIImage(named: "chevron_right")
        let chevronIconView = UIImageView(image: chevronIcon)
        chevronIconView.frame = CGRect(x: 0, y: 0, width: 28, height: 28)

        cell!.accessoryView = chevronIconView
        cell!.set(playlist: playlists[indexPath.row])
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlistViewController = PlaylistViewController()
        playlistViewController.playlist = playlists[indexPath.row]
        self.navigationController?.pushViewController(playlistViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Fetching Data

extension PlaylistListViewController {

    func loadPlaylists(completion: @escaping (Paginated<SimplifiedPlaylist>?) -> Void) {

        guard userSession != nil else { return }

        // Check if access token is valid or has to be refreshed
        if userSession!.isExpired {
            refreshToken { (res) in
                if res {
                    self.loadPlaylists(completion: completion)
                }
            }
        } else {
            fetchPlaylists { (res) in
                completion(res)
            }
        }

    }

    func fetchPlaylists(completion: @escaping (Paginated<SimplifiedPlaylist>?) -> Void) {
        spotifyApi.fetchPlaylists(authorizationValue: userSession!.authorizationValue) { (res) in
            switch res {
            case .success(let response):
                completion(response)
                os_log("Fetching user playlists", type: .info)
            case .failure(let err):
                completion(nil)
                os_log("API request to get user playlists failed with error: %@", type: .error, String(describing: err))
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
