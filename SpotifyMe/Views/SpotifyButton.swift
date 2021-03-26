//
//  SpotifyButton.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 26/03/21.
//

import UIKit

class SpotifyButton: UIButton {

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "Continue with Spotify"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private let iconView: UIImageView  = {
        let spotifyIcon =  UIImageView(image: #imageLiteral(resourceName: "spotify_icon"))
        spotifyIcon.contentMode = .scaleAspectFit
        return spotifyIcon
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.5

        addSubview(iconView)
        addSubview(buttonLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        iconView.frame = CGRect(x: (frame.height-24)/2+5, y: (frame.height-24)/2, width: 24, height: 24).integral
        buttonLabel.frame = CGRect(x: (frame.height-24)/2+44, y: 10, width: frame.width-55, height: frame.height-20).integral
    }

}
