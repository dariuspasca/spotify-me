//
//  UIImageView+Ext.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 27/03/21.
//

import UIKit
import os.log

// var imageCache = NSCache<AnyObject, AnyObject>()

// MARK: - Download image from URL and cache

extension UIImageView {

    func loadImage(from url: URL) {
        // Search if image is already saved locally
        if let cacheImage = self.loadImageFromDiskWith(imageName: url.lastPathComponent) {
            self.image = cacheImage
            return
        }

//        if let cacheImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
//            self.image = cacheImage
//            return
//        }

        // If not saved, save locally
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                os_log("Couldn't download image with error: %@", type: .error, String(describing: error))
                return
            }

            guard let data = data else { return }

            guard let image = UIImage(data: data) else { return }
            self.saveImage(imageName: url.lastPathComponent, image: image)
           // imageCache.setObject(image!, forKey: url as AnyObject)

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()

    }
}

// MARK: - Local image manager

extension UIImageView {

    func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        do {
            try data.write(to: fileURL)
        } catch let error {
            os_log("Error saving image with error: %@", type: .error, String(describing: error))
        }
    }

    func loadImageFromDiskWith(imageName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }

        return nil
    }

}
