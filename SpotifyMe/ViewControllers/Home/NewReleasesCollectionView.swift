//
//  NewReleasesCollectionViewExtension.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 13/04/21.
//
import UIKit

extension HomeViewController {

    func configureNewReleasesCollectionView() {
        // Collection header
        configureNewReleasesLabel()

        contentView.addSubview(newReleasesCollectionView)
        setNewReleasesCollectionViewDelegates()
        newReleasesCollectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: "NewReleaseCell")
        setNewReleasesCollectionViewConstraints()
    }

    func setNewReleasesCollectionViewDelegates() {
        newReleasesCollectionView.delegate = self
        newReleasesCollectionView.dataSource = self
    }

    func setNewReleasesCollectionViewConstraints() {
        let constraints = [
            newReleasesCollectionView.topAnchor.constraint(equalTo: newReleasesLabel.bottomAnchor, constant: 10),
            newReleasesCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            newReleasesCollectionView.heightAnchor.constraint(equalToConstant: view.bounds.width * 2.75),
            newReleasesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureNewReleasesLabel() {
        contentView.addSubview(newReleasesLabel)
        newReleasesLabel.text = "New Releases"
        newReleasesLabel.addCharacterSpacing(kernValue: 1)
        setNewReleasesLabelConstraints()
    }

    func setNewReleasesLabelConstraints() {
        let constraints = [
            newReleasesLabel.topAnchor.constraint(equalTo: topTracksTableView.bottomAnchor, constant: 20),
            newReleasesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
