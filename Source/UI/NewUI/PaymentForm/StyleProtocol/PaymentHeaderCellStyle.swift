//
//  PaymentHeaderCellStyle.swift
//  Frames
//
//  Created by Ehab Alsharkawy
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

public protocol PaymentHeaderCellStyle {
    var backgroundColor: UIColor { get }
    var headerLabel: ElementStyle? { get }
    var subtitleLabel: ElementStyle? { get }
    var schemeIcons: [UIImage?] { get }
}
