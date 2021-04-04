//
//  LoadingSpinnerView.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 04/04/21.
//

import UIKit

class LoadingSpinnerView: UIView {

    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        loadingLabel.text = text
        configureStackView()
        configureComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var loadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(named: "light_gray")
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        return spinner
    }()

    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    func configureStackView() {
        addSubview(stackView)
        setStackViewConstraints()
    }

    func setStackViewConstraints() {
        let constraints = [ stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureComponents() {
        stackView.addArrangedSubview(loadingSpinner)
        stackView.addArrangedSubview(loadingLabel)
    }
}
