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
    var userSession: UserSession?
    let sessionManager = UserSessionManager()
    let profileManager = UserProfileManager()

    @IBOutlet weak var connectToSpotify: UIButton!
    @IBOutlet weak var fetchData: UIButton!

    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
        let authorizationCode = UserDefaults.standard.string(forKey: "authorizationCode")

        guard authorizationCode != nil else {
            return
        }

        userSession = sessionManager.fetchUserSession(withAuthorizationCode: authorizationCode!)

    }

    // MARK: - Actions
    @IBAction func connect(_ sender: Any) {
        let connectString = SpotifyApi.init().authorizationRequestURL()
        UIApplication.shared.open(connectString)
    }

    @IBAction func getProfile(_ sender: Any) {
        // myPlaylists()
        myProfile()
    }

    func myPlaylists() {
        os_log("Fetching user playlists", type: .info)

        os_log("Fetching UserProfile from API request", type: .info)
        guard userSession == nil else {
            spotifyApi.fetchPlaylists(authorizationValue: userSession!.authorizationValue) { (res) in
                switch res {
                case .success(let response):

                    print(response)

                case .failure(let err):
                    os_log("API request to get user playlists failed with error: %@", type: .error, String(describing: err))
                }
            }
            return
        }    }

    func myProfile() {
        os_log("Fetching UserProfile from API request", type: .info)
        guard userSession == nil else {
            spotifyApi.fetchProfile(authorizationValue: userSession!.authorizationValue) { (res) in
                switch res {
                case .success(let response):

                    var followersCount: Int16?
                    var profileImage: URL?

                    if let followers = response.followers?.total {
                        followersCount = Int16(followers)
                    }

                    if let image = response.images?.first {
                        profileImage = URL(string: image.url)
                    }

                    // swiftlint:disable:next line_length
                    self.profileManager.createUserProfile(displayName: response.displayName, email: response.email, product: response.product, followers: followersCount, image: profileImage, session: self.userSession!)

                case .failure(let err):
                    os_log("API request to get UserProfile failed with error: %@", type: .error, String(describing: err))
                }
            }
            return
        }
    }
}
