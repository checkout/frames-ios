//
//  Theme.swift
//  Frames
//
//  Created by Harry Brown on 23/03/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import CheckoutEventLoggerKit

class Theme: PropertyProviding, Equatable {
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.properties == rhs.properties
    }

    var properties: [FramesLogEvent.Property: AnyCodable] {
        return [
            .primaryBackgroundColor: CheckoutTheme.primaryBackgroundColor.rawProperties,
            .secondaryBackgroundColor: CheckoutTheme.secondaryBackgroundColor.rawProperties,
            .tertiaryBackgroundColor: CheckoutTheme.tertiaryBackgroundColor.rawProperties,
            .primaryTextColor: CheckoutTheme.color.rawProperties,
            .secondaryTextColor: CheckoutTheme.secondaryColor.rawProperties,
            .errorTextColor: CheckoutTheme.errorColor.rawProperties,
            .chevronColor: CheckoutTheme.chevronColor.rawProperties,
            .font: CheckoutTheme.font.rawProperties,
            .barStyle: CheckoutTheme.barStyle.stringValue
        ].mapValues(AnyCodable.init(_:))
    }
}
