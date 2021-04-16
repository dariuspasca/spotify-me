//
//  RankedTrackTableViewCell.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 13/04/21.
//

import UIKit

class RankedTrackTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureRankLabel()
        configureImageView()
        configureStackView()
        configureLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(track: Track, rank: Int) {
        titleLabel.text = track.name
        rankLabel.text = String(rank)

        if let artists = track.artists?.allObjects as? [Artist] {
            authorLabel.text = artists.map { ($0.name!)}.joined(separator: ",")
        }

        if let albums = track.albums?.allObjects as? [Album] {
            coverImage.loadImage(from: albums.first!.coverImage!)
        }
    }

    // MARK: - Views

    lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "dark_gray")
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var coverImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(named: "dark_gray")
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(named: "light_gray")
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 3

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    func configureRankLabel() {
        contentView.addSubview(rankLabel)
        setRankLabelConstraints()
    }

    func setRankLabelConstraints() {
        let constraints = [
            rankLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rankLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            rankLabel.widthAnchor.constraint(equalToConstant: 25)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureImageView() {
        contentView.addSubview(coverImage)
        setImageViewConstraints()
    }

    func setImageViewConstraints() {
        let constraints = [
            coverImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            coverImage.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 20),
            coverImage.heightAnchor.constraint(equalToConstant: 60),
            coverImage.widthAnchor.constraint(equalToConstant: 60)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureStackView() {
        contentView.addSubview(stackView)
        setStackViewConstraints()
    }

    func setStackViewConstraints() {
        let constraints = [ stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                            stackView.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 20),
                            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureLabels() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(authorLabel)
    }

}
