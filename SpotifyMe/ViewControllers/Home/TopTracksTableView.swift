//
//  TopTracksTableView.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 13/04/21.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func configureTopTracksTableView() {
        // Table header
        configureTopTracksLabel()

        contentView.addSubview(topTracksTableView)
        setTopTracksTableViewDelegates()
        topTracksTableView.rowHeight = 80
        topTracksTableView.register(RankedTrackTableViewCell.self, forCellReuseIdentifier: "TopTrackCell")
        setTopTrackTableViewConstraints()
    }

    func setTopTracksTableViewDelegates() {
        topTracksTableView.delegate = self
        topTracksTableView.dataSource = self
    }

    func setTopTrackTableViewConstraints() {
        topTracksTableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            topTracksTableView.topAnchor.constraint(equalTo: topTracksLabel.bottomAnchor, constant: 10),
            topTracksTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            topTracksTableView.heightAnchor.constraint(equalToConstant: topTracksTableView.rowHeight*10)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureTopTracksLabel() {
        contentView.addSubview(topTracksLabel)
        topTracksLabel.text = "Weekly Top Tracks"
        topTracksLabel.addCharacterSpacing(kernValue: 1)
        setTopTracksConstraints()
    }

    func setTopTracksConstraints() {
        let constraints = [
            topTracksLabel.topAnchor.constraint(equalTo: featuredPlaylistsCollectionView.bottomAnchor, constant: 20),
            topTracksLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (topTracks != nil) ? 10 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopTrackCell") as? RankedTrackTableViewCell
        cell?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        cell?.set(track: topTracks![indexPath.row], rank: indexPath.row + 1)
        return cell!
    }
}
