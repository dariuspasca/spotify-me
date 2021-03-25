//
//  WelcomeViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 25/03/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureStackView()
        configureImageView()
        configureAppNameLabel()
    }

    // MARK: - Layout

    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 12
        stack.alignment = .bottom
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var imageView: UIImageView = {
        let image = UIImageView(image: "🎵".image(size: CGSize(width: 40, height: 45)))
        return image
    }()

    lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "SpotifyMe"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func configureStackView() {
        view.addSubview(stackView)
        setStackViewConstaints()
    }

    func setStackViewConstaints() {
        let constraints = [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureImageView() {
        stackView.addArrangedSubview(imageView)
    }

    func configureAppNameLabel() {
        stackView.addArrangedSubview(appNameLabel)
    }
}

extension String {
    func image(size: CGSize) -> UIImage? {
        let size = size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
