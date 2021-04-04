//
//  UIViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 04/04/21.
//

import UIKit

private var customSpinner: LoadingSpinnerView?

extension UIViewController {

    func showLoadingSpinner() {
        customSpinner = LoadingSpinnerView(frame: self.view.bounds, text: "Loading")
        self.view.addSubview(customSpinner!)
    }

    func removeLoadingSpinner() {
        DispatchQueue.main.async {
            customSpinner?.removeFromSuperview()
            customSpinner = nil
        }
    }

}
