//
//  TabBarViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 12/04/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }

}

// MARK: - Setup

extension TabBarViewController {

    func setupVCs() {
        viewControllers = [
            createNavController(for: HomeViewController(), title: "Home", image: UIImage(systemName: "house")!),
            createNavController(for: PlaylistListViewController(), title: "Search", image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: PlaylistListViewController(), title: "Library", image: UIImage(systemName: "book")!)
        ]
    }

    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}
