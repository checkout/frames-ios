//
//  PaymentStyle.swift
//  
//
//  Created by Alex Ioja-Yang on 26/07/2022.
//

import Foundation

public struct PaymentStyle {
    let paymentFormStyle: PaymentFormStyle
    let billingFormStyle: BillingFormStyle

    /**
     Define the payment form UI Styling
     
     - Parameters:
        - paymentFormStyle: UI Styling for the payment form, the root screen handling the payment
        - billingFormStyle: UI Styling for the billing form if the user will interact with the address billing
     */
    public init(paymentFormStyle: PaymentFormStyle,
                billingFormStyle: BillingFormStyle) {
        self.paymentFormStyle = paymentFormStyle
        self.billingFormStyle = billingFormStyle
    }

}
