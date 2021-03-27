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

        configureStacksView()
        configureImageView()
        configureLabels()
        configureSpotifyButton()
    }

    // MARK: - Views

    var appStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 12
        stack.alignment = .bottom

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    var heroeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        stack.alignment = .center

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    var imageView: UIImageView = {
        let image = UIImageView(image: "🎵".image(size: CGSize(width: 40, height: 45)))
        return image
    }()

    var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "SpotifyMe"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var heroeLabelA: UILabel = {
        let label = UILabel()
        label.text = "Listening is"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var heroeLabelB: UILabel = {
        let label = UILabel()
        label.text = "Everything"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var spotifyButton:SpotifyButton = {
        let myButton = SpotifyButton(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
        myButton.backgroundColor = .black
        myButton.translatesAutoresizingMaskIntoConstraints = false
        myButton.addTarget(self, action: #selector(redirectToSpotify(_:)), for: .touchUpInside)
        return myButton
    }()

    // MARK: - Layout

    func configureStacksView() {
        view.addSubview(appStackView)
        view.addSubview(heroeStackView)
        setStackViewsConstaints()
    }

    func setStackViewsConstaints() {
        let constraints = [
            appStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -170),
            appStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            heroeStackView.topAnchor.constraint(equalTo: appStackView.topAnchor, constant: 100),
            heroeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureImageView() {
        appStackView.addArrangedSubview(imageView)
        setImageViewConstraints()
    }

    func setImageViewConstraints() {
        let constraints = [
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 45)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureLabels() {
        appStackView.addArrangedSubview(appNameLabel)
        heroeStackView.addArrangedSubview(heroeLabelA)
        heroeStackView.addArrangedSubview(heroeLabelB)
        setLabelsConstraints()
    }

    func setLabelsConstraints() {
        let constraints = [
            appNameLabel.widthAnchor.constraint(equalToConstant: 150),
            heroeLabelA.widthAnchor.constraint(equalToConstant: view.frame.width/2.5),
            heroeLabelB.widthAnchor.constraint(equalToConstant: view.frame.width/2.5)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureSpotifyButton() {
        view.addSubview(spotifyButton)
        setSpotifyButtonConstraints()
    }

    func setSpotifyButtonConstraints() {
        let constraints = [
            spotifyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            spotifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spotifyButton.widthAnchor.constraint(equalToConstant: 300),
            spotifyButton.heightAnchor.constraint(equalToConstant: 60)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Actions

    @objc func redirectToSpotify(_ sender: UIButton?) {
        let connectString = SpotifyApi.init().authorizationRequestURL()
        UIApplication.shared.open(connectString)
    }

}
