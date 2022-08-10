//
//  Theme+Title.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated Title style
    struct ThemeTitle: ElementStyle {
        public var text: String
        public var isHidden: Bool = false
        public var font: UIFont
        public var backgroundColor: UIColor = .clear
        public var textColor: UIColor
    }

    /// Create a Title Style from text
    func buildTitle(text: String) -> ThemeTitle {
        ThemeTitle(text: text,
                   font: UIFont.systemFont(ofSize: self.titleFontSize),
                   textColor: self.primaryFontColor)
    }

}
