//
//  DefaultPaymentHeaderCellStyle.swift
//  Frames
//
//  Created by Ehab Alsharkawy.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

public struct DefaultPaymentHeaderCellStyle: PaymentHeaderCellStyle {
    public var shouldHideAcceptedCardsList = false
    public var backgroundColor: UIColor = .white
    public var headerLabel: ElementStyle? = DefaultHeaderLabelFormStyle(text: LocalizationKey.paymentDetails.localizedValue)
    public var subtitleLabel: ElementStyle? = DefaultTitleLabelStyle(
        text: LocalizationKey.acceptedCards.localizedValue,
        font: UIFont.systemFont(ofSize: Constants.Style.PaymentForm.Header.subtitleFontSize.rawValue))
    public var schemeIcons: [UIImage?] = [
        Constants.Bundle.SchemeIcon(scheme: .visa).image,
        Constants.Bundle.SchemeIcon(scheme: .mastercard).image,
        Constants.Bundle.SchemeIcon(scheme: .americanExpress).image
    ]
}
