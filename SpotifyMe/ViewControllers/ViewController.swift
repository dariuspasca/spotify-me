//
//  ViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 11/03/21.
//

import UIKit
import os.log


class ViewController: UIViewController {
    
    let spotifyApi = SpotifyApi.init()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userSession: UserSession?
    
    
    @IBOutlet weak var connectToSpotify: UIButton!
    @IBOutlet weak var fetchData: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func fetchUserSession() {
        do {
            os_log("Fetching user session", type: .info)
            self.userSession = try context.fetch(UserSession.fetchRequest()).first
        } catch  {
            os_log("Failed to fetch user session with error: %@", type:.error, String(describing: error))
        }
    }
    
    //MARK: Actions
    @IBAction func connect(_ sender: Any) {
        let connectString = SpotifyApi.init().authorizationRequestURL()
        UIApplication.shared.open(connectString)
    }
    
    
    @IBAction func getProfile(_ sender: Any) {
       fetchUserSession()
        
        guard (userSession == nil) else {
            spotifyApi.fetchSpotifyProfile(authorizationValue: userSession!.authorizationValue) { (res) in
                switch res {
                case .success(let response):
                    
                    // Create a UserProfile object
                    let user = UserProfile(context: self.context)
                    user.displayName = response.displayName
                    user.email = response.email
                    user.product = response.product
                    user.profileUri = URL(string: response.uri)
                    
                    if let followers = response.followers?.total {
                        user.followers = Int16(followers)
                    }
                    
                    if let image = response.images?.first {
                        user.profileImage = URL(string: image.url ?? "")
                    }
                    
                    // Save UserProfile
                    do {
                        try self.context.save()
                        os_log("Saved new UserProfile", type: .info)
                    } catch  {
                        os_log("Failed to save new UserProfile with error: %@", type:.error, String(describing: error))
                    }
                    
                    
                case .failure(let err):
                    os_log("Request to get UserProfile failed with error: %@", type:.error, String(describing: err))
                }
            }
            return
        }
    }
}


