//
//  DefaultPaymentHeaderCellStyle.swift
//  Frames
//
//  Created by Ehab Alsharkawy.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

public struct DefaultPaymentHeaderCellStyle: PaymentHeaderCellStyle {
  public var backgroundColor: UIColor = .clear
  public var headerLabel: ElementStyle? = DefaultHeaderLabelFormStyle(text: Constants.LocalizationKeys.PaymentForm.Header.title)
  public var subtitleLabel: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.PaymentForm.Header.subtitle)
  public var schemeIcons: [UIImage?]? = [
    Constants.Bundle.SchemeIcon(scheme: .visa).image,
    Constants.Bundle.SchemeIcon(scheme: .mastercard).image,
    Constants.Bundle.SchemeIcon(scheme: .americanExpress).image]
}
