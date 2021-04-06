//
//  DynamicTextViewSize.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 06/04/21.
//
// Credits:  Rebeloper - Rebel Developer https://www.youtube.com/channel/UCK88iDIf2V6w68WvC-k7jcg


import UIKit

struct DynamicTextViewSize {

    static func height(text: String?, font: UIFont, width: CGFloat) -> CGFloat {

        var currentHeight: CGFloat!

        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        textView.text = text
        textView.font = font
        textView.sizeToFit()

        currentHeight = textView.frame.height

        return currentHeight
    }
}
