//
//  ArtistCollectionViewCell.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 12/04/21.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear

        configureStackView()
        configureCoverImageView()
        configureArtistLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(artist: Artist) {
        artistLabel.text = artist.name

        if let coverUrl = artist.coverImage {
            coverImage.loadImage(from: coverUrl)
        }
    }

    // MARK: - Views

    lazy var coverImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = (contentView.bounds.height * 0.8) / 2
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.textColor = UIColor(named: "light_gray")
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 10
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
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureCoverImageView() {
        stackView.addArrangedSubview(coverImage)
        setCoverImageViewConstraints()
    }

    func setCoverImageViewConstraints() {
        let constraints = [
            coverImage.heightAnchor.constraint(equalToConstant: contentView.bounds.height * 0.8),
            coverImage.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.8)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureArtistLabel() {
        stackView.addArrangedSubview(artistLabel)
        setArtistLabelConstraints()
    }

    func setArtistLabelConstraints() {
        let constraints = [
            artistLabel.centerXAnchor.constraint(equalTo: coverImage.centerXAnchor),
            artistLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.9)
        ]

        NSLayoutConstraint.activate(constraints)
    }

}
