//
//  PaymentHeaderCellStyle.swift
//  Frames
//
//  Created by Ehab Alsharkawy
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

public protocol PaymentHeaderCellStyle {
    var shouldHideAcceptedCardsList: Bool { get }
    var backgroundColor: UIColor { get }
    var headerLabel: ElementStyle? { get }
    var subtitleLabel: ElementStyle? { get }
}
