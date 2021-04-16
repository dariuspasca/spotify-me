//
//  TabBarViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 12/04/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }

}

// MARK: - Setup

extension TabBarController {

    func setupVCs() {
        viewControllers = [
            createNavController(for: HomeViewController(), title: "Home", image: UIImage(systemName: "house")!),
            createNavController(for: LibraryViewController(), title: "Search", image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: LibraryViewController(), title: "Library", image: UIImage(systemName: "book")!)
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
