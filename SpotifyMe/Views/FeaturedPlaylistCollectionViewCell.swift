//
//  FeaturedPlaylistCollectionViewCell.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 13/04/21.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear

        configureCoverImageView()
       // configurePlaylistLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(playlist: Playlist) {
        playlistLabel.text = playlist.name

        if let coverUrl = playlist.coverImage {
            coverImage.loadImage(from: coverUrl)
        }
    }

    // MARK: - Views

    lazy var coverImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = (contentView.bounds.height * 0.9) / 6
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var playlistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func configureCoverImageView() {
        contentView.addSubview(coverImage)
        setCoverImageViewConstraints()
    }

    func setCoverImageViewConstraints() {
        let constraints = [
            coverImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: contentView.bounds.height * 0.9),
            coverImage.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.9)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configurePlaylistLabel() {
        contentView.addSubview(playlistLabel)
        setPlaylistLabelConstraints()
    }

    func setPlaylistLabelConstraints() {
        let constraints = [
            playlistLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playlistLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playlistLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.8)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
