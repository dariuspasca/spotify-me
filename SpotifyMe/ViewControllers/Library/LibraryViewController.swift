//
//  PlaylistListViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 26/03/21.
//

import UIKit
import os.log

class LibraryViewController: UIViewController {

    var tableView = UITableView()
    var playlists: [Playlist]?

    private var libraryViewModel: LibraryViewModel!
    private let playlistManager = PlaylistManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Playlists"

        configureTableView()

        // Setup notifications
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePrivatePlaylists(notification:)), name: .didDownloadPrivatePlaylists, object: nil)

        // Init view model
        libraryViewModel = LibraryViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        guard playlists != nil else {
            self.showLoadingSpinner()
            return
        }
    }

    // MARK: - Notifications

    @objc func didReceivePrivatePlaylists(notification: NSNotification) {
        if let error = notification.object as? NSError {
            // should handle errror
            print(error)
        } else {
            playlists = playlistManager.fetchPlaylists(withType: "private")
            DispatchQueue.main.async {
                self.removeLoadingSpinner()
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Layouts

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

// MARK: - TableView

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists?.count ?? 0
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
        cell!.set(playlist: playlists![indexPath.row])
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlistViewController = PlaylistViewController()
        playlistViewController.playlist = playlists![indexPath.row]
        self.navigationController?.pushViewController(playlistViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
