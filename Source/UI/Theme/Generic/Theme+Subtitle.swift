//
//  Theme+Subtitle.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated Subtitle style
    struct ThemeSubtitle: ElementStyle {
        public var text: String
        public var textAlignment: NSTextAlignment = .natural
        public var textColor: UIColor
        public var backgroundColor: UIColor = .clear
        public var tintColor: UIColor
        public var image: UIImage?
        public var height: Double = 30
        public var isHidden = false
        public var font: UIFont
    }

    /// Create a Subtitle Style from text and optional image
    func buildSubtitle(text: String,
                       image: UIImage? = nil) -> ThemeSubtitle {
        ThemeSubtitle(text: text,
                      textColor: self.secondaryFontColor,
                      tintColor: self.secondaryFontColor,
                      image: image,
                      font: subtitleFont)
    }
}
