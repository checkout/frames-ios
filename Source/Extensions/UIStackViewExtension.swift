//
//  UIStackViewExtension.swift
//  Frames
//
//  Created by Ehab Alsharkawy
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

extension UIStackView {

    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
