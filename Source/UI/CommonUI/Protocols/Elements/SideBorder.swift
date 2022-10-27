//
//  SideBorder.swift
//  Frames
//
//  Created by Ehab Alsharkawy on 26/10/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

public enum SideBorder: CaseIterable {
    public static var allCases: [SideBorder] = [.left(layer: nil), .right(layer: nil), .top(layer: nil), .bottom(layer: nil)]
    case left(layer: UIView?)
    case right(layer: UIView?)
    case top(layer: UIView?)
    case bottom(layer: UIView?)
}
