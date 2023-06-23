//
//  Theme+Border.swift
//  
//
//  Created by Alex Ioja-Yang on 15/06/2023.
//

import UIKit

public extension Theme {

    struct ThemeBorderStyle: ElementBorderStyle {
        public var cornerRadius: CGFloat
        public var borderWidth: CGFloat
        public var normalColor: UIColor
        public var focusColor: UIColor
        public var errorColor: UIColor
        public var edges: UIRectEdge?
        public var corners: UIRectCorner?
    }

}
