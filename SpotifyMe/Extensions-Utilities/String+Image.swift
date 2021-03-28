//
//  String+Ext.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 26/03/21.
//
// Credits: Luca Angeletti https://stackoverflow.com/questions/38809425/convert-apple-emoji-string-to-uiimage

import UIKit

extension String {
    func image(size: CGSize) -> UIImage? {
        let size = size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
