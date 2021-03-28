//
//  PlaylistHeaderView.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 28/03/21.
//

import UIKit

class PlaylistHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        configureImageView()
        configureStackView()
        configureLabels()
        // swiftlint:disable:next line_length
        addSeparator(at: .bottom, color: UIColor(named: "almost_white")!, weight: 1.2, insets: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 15.0, right: 20.0))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(playlist: SimplifiedPlaylist) {
        titleLabel.text = playlist.name
        tracksLabel.text = "\(playlist.tracks.total) songs"
        coverImage.loadImage(from: playlist.images!.first!.url)
    }

    // MARK: - Views

    var coverImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()

    var playlistStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 3

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(named: "dark_gray")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var tracksLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(named: "light_gray")
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
        let constraints = [ coverImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
                            coverImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                            coverImage.heightAnchor.constraint(equalToConstant: 120),
                            coverImage.widthAnchor.constraint(equalToConstant: 120)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureStackView() {
        addSubview(playlistStackView)
        setStackViewConstraints()
    }

    func setStackViewConstraints() {
        let constraints = [ playlistStackView.topAnchor.constraint(equalTo: topAnchor,constant: 30),
                            playlistStackView.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 20),
                            playlistStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureLabels() {
        playlistStackView.addArrangedSubview(titleLabel)
        playlistStackView.addArrangedSubview(tracksLabel)
    }
}
