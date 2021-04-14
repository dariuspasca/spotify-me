//
//  NewReleaseCollectionViewCell.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 13/04/21.
//

import UIKit

class NewReleaseCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear

        configureCoverImageView()
        configureStackView()
        configureAlbumLabel()
        configureArtistLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(album: Album) {
        albumLabel.text = album.name
        if let artists = album.artists?.allObjects as? [Artist] {
            artistLabel.text = artists.map { ($0.name!)}.joined(separator: ",")
        }

        if let coverUrl = album.coverImage {
            coverImage.loadImage(from: coverUrl)
        }
    }

    // MARK: - Views

    lazy var coverImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius =  15
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var albumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(named: "dark_gray")
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(named: "light_gray")
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 0
        stack.backgroundColor = .clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    func configureStackView() {
        contentView.addSubview(stackView)
        setStackViewConstraints()
    }

    func setStackViewConstraints() {
        let constraints = [
            stackView.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 7),
            stackView.widthAnchor.constraint(equalTo: coverImage.widthAnchor),
            stackView.leadingAnchor.constraint(equalTo: coverImage.leadingAnchor, constant: 10)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureCoverImageView() {
        contentView.addSubview(coverImage)
        setCoverImageViewConstraints()
    }

    func setCoverImageViewConstraints() {
        let constraints = [
            coverImage.heightAnchor.constraint(equalToConstant: contentView.bounds.width * 0.85),
            coverImage.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.85),
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureAlbumLabel() {
        stackView.addArrangedSubview(albumLabel)
    }

    func configureArtistLabel() {
        stackView.addArrangedSubview(artistLabel)
    }

}
