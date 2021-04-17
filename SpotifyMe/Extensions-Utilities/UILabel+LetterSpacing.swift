//
//  UILabel+LetterSpacing.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 17/04/21.
//
// Credits: https://gist.github.com/nitin-agam/3ec783853797fe06dbea369f3a7c347e

import UIKit

extension UILabel {

    func addCharacterSpacing(kernValue: Double = 3) {
        if let labelText = text, labelText.isEmpty == false {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.kern,
                                          value: kernValue,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
