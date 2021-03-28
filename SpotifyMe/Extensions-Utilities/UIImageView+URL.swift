//
//  UIImageView+Ext.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 27/03/21.
//
// Credits: Let's Build That App https://www.youtube.com/channel/UCuP2vJ6kRutQBfRmdcI92mA

import UIKit
import os.log

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImage(from url: URL) {

        if let cacheImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                os_log("Couldn't download image with error: %@", type: .error, String(describing: error))
                return
            }

            guard let data = data else { return }
            let image = UIImage(data: data)
            imageCache.setObject(image!, forKey: url as AnyObject)

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()

    }
}
