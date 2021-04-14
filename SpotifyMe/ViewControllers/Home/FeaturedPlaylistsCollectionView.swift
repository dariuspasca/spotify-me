//
//  FeaturedPlaylistsCollectionViewExtension.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 13/04/21.
//

import UIKit

// MARK: - Setup & Constraints

extension HomeViewController {

    func configureFeaturedPlaylistCollectionView() {
        // Collection header
        configureFeaturedPlaylistLabel()

        contentView.addSubview(featuredPlaylistsCollectionView)
        setFeaturedPlaylistCollectionViewDelegates()
        featuredPlaylistsCollectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: "FeaturedPlaylistCell")
        setFeaturedPlaylistCollectionViewConstraints()
    }

    func setFeaturedPlaylistCollectionViewDelegates() {
        featuredPlaylistsCollectionView.delegate = self
        featuredPlaylistsCollectionView.dataSource = self
    }

    func setFeaturedPlaylistCollectionViewConstraints() {
        let constraints = [
            featuredPlaylistsCollectionView.topAnchor.constraint(equalTo: featuredPlaylistsLabel.bottomAnchor),
            featuredPlaylistsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            featuredPlaylistsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            featuredPlaylistsCollectionView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.2)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureFeaturedPlaylistLabel() {
        contentView.addSubview(featuredPlaylistsLabel)
        featuredPlaylistsLabel.text = "Featured Playlists"
        setFeatuedPlaylistLabelConstraints()
    }

    func setFeatuedPlaylistLabelConstraints() {

        let constraints = [
            featuredPlaylistsLabel.topAnchor.constraint(equalTo: popularArtistsCollectionView.bottomAnchor, constant: 20),
            featuredPlaylistsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
