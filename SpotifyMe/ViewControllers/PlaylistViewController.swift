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
    let downloadManager = DownloadManager()
    var tracks: [Track]?
    var playlist:Playlist!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        self.title = playlist.name

        configureTableView()
        loadTracks()
    }

    override func viewWillAppear(_ animated: Bool) {
        guard tracks != nil else {
            self.showLoadingSpinner()
            return
        }
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

    func loadTracks() {
        if (playlist.tracks!.allObjects.isEmpty) {
            downloadManager.downloadTracks(playlist: playlist.id!) { (result) in
                switch result {
                case .success:
                    if let playlistTracks = self.playlist.tracks!.allObjects as? [Track] {
                        self.tracks = playlistTracks
                    }
                    DispatchQueue.main.async {
                        self.removeLoadingSpinner()
                        self.tableView.reloadData()
                    }
                case .failure(let err):
                    // Failed fetching playlist, should handle error (UI)
                    self.removeLoadingSpinner()
                    print(err)
                }

            }
        } else {
            if let playlistTracks = playlist.tracks!.allObjects as? [Track] {
                self.tracks = playlistTracks
            }
        }
    }
}

// MARK: - Table Data

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as? TrackViewCell
        cell!.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        cell!.set(track: tracks![indexPath.row])
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = tracks![indexPath.row]
        let lyricsViewcontroller = LyricsViewController()
        lyricsViewcontroller.track = track
        let navController = UINavigationController(rootViewController: lyricsViewcontroller)
        present(navController, animated: true, completion: nil)
    }
}
