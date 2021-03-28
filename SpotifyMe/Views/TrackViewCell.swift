//
//  TrackTableViewCell.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 28/03/21.
//

import UIKit

class TrackViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureImageView()
        configurePlaylistTitleLabel()
        configurePlaylistAuthorLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(track: SimplifiedTrack) {
        titleLabel.text = track.name
        authorLabel.text = track.artists.map({$0.name}).joined(separator: ",")

        coverImage.loadImage(from: track.album.images.first!.url)

    }

    // MARK: - Views

    var coverImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(named: "dark_gray")
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
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
        let constraints = [ coverImage.centerYAnchor.constraint(equalTo: centerYAnchor),
                            coverImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                            coverImage.heightAnchor.constraint(equalToConstant: 80),
                            coverImage.widthAnchor.constraint(equalToConstant: 80)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configurePlaylistTitleLabel() {
        addSubview(titleLabel)
        setPlaylistTitleLabelsConstraints()
    }

    func setPlaylistTitleLabelsConstraints() {
        let constraints = [ titleLabel.topAnchor.constraint(equalTo: topAnchor,constant: 25),
                            titleLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 20),
                            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55),
                            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configurePlaylistAuthorLabel() {
        addSubview(authorLabel)
        setPlaylistAuthorLabelsConstraints()
    }

    func setPlaylistAuthorLabelsConstraints() {
        let constraints = [ authorLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 25),
                            authorLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 20),
                            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55),
                            authorLabel.heightAnchor.constraint(equalToConstant: 25)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
