//
//  PlaylistListViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 26/03/21.
//

import UIKit
import os.log

class PlaylistListVideoController: UIViewController {

    var tableView = UITableView()
    let spotifyApi = SpotifyApi.init()
    let sessionManager = UserSessionManager()
    var playlists = [SimplifiedPlaylist]()
    var userSession: UserSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Playlists"
        view.backgroundColor = .white

        let authorizationCode = UserDefaults.standard.string(forKey: "authorizationCode")

        userSession = sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode!)
        if userSession != nil {
            fetchPlaylists { (res) in
                if res != nil {
                    self.playlists = res!.items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
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

// MARK: - Table Delegate

extension PlaylistListVideoController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell") as! PlaylistViewCell
        cell.set(playlist: playlists[indexPath.row])
        return cell
    }
}

// MARK: - Fetching Playlists

extension PlaylistListVideoController {

    func fetchPlaylists(completion: @escaping (Paginated<SimplifiedPlaylist>?) -> Void) {
        os_log("Fetching user playlists", type: .info)
        spotifyApi.fetchPlaylists(authorizationValue: userSession!.authorizationValue) { (res) in
            switch res {
            case .success(let response):
                completion(response)
            case .failure(let err):
                completion(nil)
                os_log("API request to get user playlists failed with error: %@", type: .error, String(describing: err))
            }
        }
        return
    }
}
