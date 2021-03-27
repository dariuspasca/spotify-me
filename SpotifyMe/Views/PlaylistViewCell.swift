//
//  PlaylistViewCell.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 26/03/21.
//

import UIKit

class PlaylistViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureImageView()
        configureStackView()
        configurePlaylistLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(playlist: SimplifiedPlaylist) {
        titleLabel.text = playlist.name
        authorLabel.text = "by \(playlist.owner.displayName ?? "Spotify user")"

        if let images = playlist.images {
            coverImage.loadImage(from: images.first!.url)
        }
    }

    // MARK: - Views

    var coverImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()

    var playlistStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = -15

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(red: 15/255, green: 11/255, blue: 16/255, alpha: 1.0)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(red: 196/255, green: 199/255, blue: 202/255, alpha: 1.0)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func configureImageView() {
        addSubview(coverImage)
        setImageViewConstraints()
    }

    func setImageViewConstraints() {
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [ coverImage.centerYAnchor.constraint(equalTo: centerYAnchor),
                            coverImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                            coverImage.heightAnchor.constraint(equalToConstant: 80),
                            coverImage.widthAnchor.constraint(equalToConstant: 80)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureStackView() {
        addSubview(playlistStackView)
        setStackViewConstraints()
    }

    func setStackViewConstraints() {
        let constraints = [ playlistStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                            playlistStackView.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 20),
                            playlistStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configurePlaylistLabels() {
        playlistStackView.addArrangedSubview(titleLabel)
        playlistStackView.addArrangedSubview(authorLabel)
        setPlaylistLabelsConstraints()
    }

    func setPlaylistLabelsConstraints() {
        let constraints = [
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            authorLabel.heightAnchor.constraint(equalToConstant: 40)
        ]

        NSLayoutConstraint.activate(constraints)
    }

}
