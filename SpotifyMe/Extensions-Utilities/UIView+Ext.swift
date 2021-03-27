//
//  UIView.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 26/03/21.
//

import UIKit

extension UIView {

    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [ topAnchor.constraint(equalTo: superView.topAnchor),
                            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
