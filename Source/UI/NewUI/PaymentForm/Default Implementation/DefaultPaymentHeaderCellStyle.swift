//
//  DefaultPaymentHeaderCellStyle.swift
//  Frames
//
//  Created by Ehab Alsharkawy.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

public struct DefaultPaymentHeaderCellStyle: PaymentHeaderCellStyle {
  public var isIconsViewHidden: Bool = false
  public var backgroundColor: UIColor = .white
  public var headerLabel: ElementStyle? = DefaultHeaderLabelFormStyle(text: Constants.LocalizationKeys.PaymentForm.Header.title)
  public var subtitleLabel: ElementStyle? = DefaultTitleLabelStyle(
    text: Constants.LocalizationKeys.PaymentForm.Header.subtitle,
    font: UIFont(graphikStyle: .regular, size: Constants.Style.PaymentForm.Header.subtitleFontSize.rawValue))
}
