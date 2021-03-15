//
//  ViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 11/03/21.
//

import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet weak var connectToSpotify: UIButton!
    @IBOutlet weak var fetchData: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Actions
    @IBAction func connect(_ sender: Any) {
        let connectString = SpotifyApi.init().authorizationRequestURL()
        UIApplication.shared.open(connectString)
    }
    
    
    @IBAction func getProfile(_ sender: Any) {
        
    }
}


