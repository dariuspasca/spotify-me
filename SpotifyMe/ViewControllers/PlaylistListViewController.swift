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
    var playlists = [Playlist]()

    let downloadManager = DownloadManager()
    let sessionManager = UserSessionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Playlists"

        let authorizationCode = UserDefaults.standard.string(forKey: "authorizationCode")
        let userSession = sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode!)

        guard userSession != nil else {
            return
        }

        if userSession!.profile!.playlists!.allObjects.isEmpty {
            downloadManager.downloadPlaylists(url: SpotifyEndpoint.myPlalists.url) {
                self.playlists = userSession!.profile!.playlists!.allObjects as! [Playlist]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            self.playlists = userSession!.profile!.playlists!.allObjects as! [Playlist]
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
