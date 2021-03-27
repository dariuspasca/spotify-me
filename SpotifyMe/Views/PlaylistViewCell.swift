//
//  PlaylistViewCell.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 26/03/21.
//

import UIKit

class PlaylistViewCell: UITableViewCell {

    var playlistCoverImage = UIImageView()
    var playlistTitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(playlistTitleLabel)
        addSubview(playlistCoverImage)

        configureImageView()
        configureTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(playlist: SimplifiedPlaylist) {
        playlistTitleLabel.text = playlist.name

        if let images = playlist.images {
            playlistCoverImage.load(url: images.first!.url)
        }
    }

    func configureImageView() {
        playlistCoverImage.layer.cornerRadius = 10
        playlistCoverImage.clipsToBounds = true
        playlistCoverImage.contentMode = .scaleAspectFill
        setImageViewConstraints()
    }

    func configureTitleLabel() {
        playlistTitleLabel.numberOfLines = 1
        playlistTitleLabel.adjustsFontSizeToFitWidth = true
        setTitleLabelConstraints()
    }

    func setImageViewConstraints() {
        playlistCoverImage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [ playlistCoverImage.centerYAnchor.constraint(equalTo: centerYAnchor),
                            playlistCoverImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                            playlistCoverImage.heightAnchor.constraint(equalToConstant: 80),
                            playlistCoverImage.widthAnchor.constraint(equalToConstant: 80)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func setTitleLabelConstraints() {
        playlistTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [ playlistTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                            playlistTitleLabel.leadingAnchor.constraint(equalTo: playlistCoverImage.trailingAnchor, constant: 20),
                            playlistTitleLabel.heightAnchor.constraint(equalToConstant: 80),
                            playlistTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ]

        NSLayoutConstraint.activate(constraints)
    }

}
