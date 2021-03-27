//
//  SceneDelegate.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 11/03/21.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // swiftlint:disable all
    var window: UIWindow?
    lazy var launchManager = LaunchManager()
    lazy var mainContext = CoreDataStack.shared.mainContext
    var isUserConnected = false
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let authorizationCode = UserDefaults.standard.string(forKey: "authorizationCode")
        isUserConnected = launchManager.isUserConnected(with: authorizationCode)

        if isUserConnected {
            let navController = UINavigationController(rootViewController: PlaylistListVideoController())
            navController.navigationBar.prefersLargeTitles = true
            window?.rootViewController = navController
        } else {
            window?.rootViewController = WelcomeViewController()
        }

        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let url = URLContexts.first?.url {
            launchManager.handleURL(url: url)
        }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        launchManager.authorizationDelegate = self
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        if mainContext.hasChanges {
            do {
                print("Saving context")
                try mainContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Failed to save context with error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension SceneDelegate: LaunchManagerDelegate {
    func didCompleteAuthorization(ready: Bool) {
        if ready {
            let navController = UINavigationController(rootViewController: PlaylistListVideoController())
            navController.navigationBar.prefersLargeTitles = true
            window?.rootViewController = navController
        } else {
            // Should handle error
            print("Error login")
        }
    }
}
