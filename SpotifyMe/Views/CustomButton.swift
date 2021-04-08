//
//  SpotifyButton.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 26/03/21.
//

import UIKit

class CustomButton: UIButton {

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private let iconView: UIImageView  = {
        let icon =  UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()

    init(frame: CGRect, title: String, icon: UIImage) {
        super.init(frame: frame)

        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.5

        buttonLabel.text = title
        iconView.image = icon

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
