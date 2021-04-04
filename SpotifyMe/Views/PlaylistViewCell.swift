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
        configureLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(playlist: Playlist) {
        titleLabel.text = playlist.name
        authorLabel.text = "by \(playlist.owner ?? "Spotify user")"

        if let coverUrl = playlist.coverImage {
            coverImage.loadImage(from: coverUrl)
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

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(named: "dark_gray")
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "light_gray")
        label.textAlignment = .left
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 3

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        addSubview(stackView)
        setStackViewConstraints()
    }
    
    func setStackViewConstraints() {
        let constraints = [ stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                            stackView.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 20),
                            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureLabels() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(authorLabel)
    }

}
