//
//  Factory+UITest.swift
//  iOS Example Frame
//
//  Created by Alex Ioja-Yang on 24/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit
import Frames
import Checkout

#if UITEST
extension Factory {

    static func getMinimalUITestVC(completionHandler: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) -> UIViewController {
        let supportedSchemes: [CardScheme] = [.visa, .mastercard, .maestro, .americanExpress, .mada]

        let configuration = PaymentFormConfiguration(apiKey: apiKey,
                                                     environment: environment,
                                                     supportedSchemes: supportedSchemes,
                                                     billingFormData: nil)
        let style = ThemeDemo.buildMinimalUITest()

        let viewController = PaymentFormFactory.buildViewController(configuration: configuration,
                                                                    style: style,
                                                                    completionHandler: completionHandler)

        return viewController
    }
}

extension ThemeDemo {

    static func buildMinimalUITest() -> PaymentStyle {
        var theme = Theme(primaryFontColor: UIColor(red: 0 / 255, green: 204 / 255, blue: 45 / 255, alpha: 1),
                          secondaryFontColor: UIColor(red: 177 / 255, green: 177 / 255, blue: 177 / 255, alpha: 1),
                          buttonFontColor: .green,
                          errorFontColor: .red,
                          backgroundColor: UIColor(red: 23 / 255, green: 32 / 255, blue: 30 / 255, alpha: 1),
                          errorBorderColor: .red)
        theme.textInputBackgroundColor = .darkGray
        theme.borderRadius = 12
        theme.borderColor = .green

        var payButton = theme.buildPayButton(text: "Pay now!")
        payButton.textAlignment = .center

        let paymentFormStyle = theme.buildPaymentForm(
            headerView: theme.buildPaymentHeader(title: "Payment details",
                                                 subtitle: "Accepting your favourite payment methods"),
            addBillingButton: nil,
            billingSummary: nil,
            cardholder: nil,
            cardNumber: theme.buildPaymentInput(isTextFieldNumericInput: true,
                                                titleText: "Card number",
                                                errorText: "Please enter valid card number",
                                                errorImage: UIImage(named: "warning")),
            expiryDate: theme.buildPaymentInput(textFieldPlaceholder: "__ / __",
                                                isTextFieldNumericInput: false,
                                                titleText: "Expiry date",
                                                errorText: "Please enter valid expiry date",
                                                errorImage: UIImage(named: "warning")),
            securityCode: nil,
            payButton: payButton)

        let billingFormStyle = theme.buildBillingForm(
            header: theme.buildBillingHeader(title: "Billing Details",
                                             cancelButtonTitle: "Cancel",
                                             doneButtonTitle: "Done"),
            cells: [])

        return PaymentStyle(paymentFormStyle: paymentFormStyle,
                            billingFormStyle: billingFormStyle)
    }

}
#endif
