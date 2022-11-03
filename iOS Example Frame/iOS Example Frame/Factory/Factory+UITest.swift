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

    static func getCompleteUITestVC(completionHandler: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) -> UIViewController {
        let supportedSchemes: [CardScheme] = [.visa, .mastercard, .maestro, .americanExpress, .mada]

        let configuration = PaymentFormConfiguration(apiKey: apiKey,
                                                     environment: environment,
                                                     supportedSchemes: supportedSchemes,
                                                     billingFormData: nil)
        let style = ThemeDemo.buildCompleteUITest()

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

        var payButton = theme.buildPayButton(text: "Pay now")
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

    // swiftlint:disable:next function_body_length
    static func buildCompleteUITest() -> PaymentStyle {
        var theme = Theme(primaryFontColor: UIColor(red: 0 / 255, green: 204 / 255, blue: 45 / 255, alpha: 1),
                          secondaryFontColor: UIColor(red: 177 / 255, green: 177 / 255, blue: 177 / 255, alpha: 1),
                          buttonFontColor: .green,
                          errorFontColor: .red,
                          backgroundColor: UIColor(red: 23 / 255, green: 32 / 255, blue: 30 / 255, alpha: 1),
                          errorBorderColor: .red)
        theme.textInputBackgroundColor = .darkGray
        theme.borderRadius = 12
        theme.borderColor = .green

        var payButton = theme.buildPayButton(text: "Pay now")
        payButton.textAlignment = .center

        var billingSummary = theme.buildBillingSummary(buttonText: "Change billing details", titleText: "Billing details")
        billingSummary.borderColor = .white
        billingSummary.borderWidth = 1

        let paymentFormStyle = theme.buildPaymentForm(
            headerView: theme.buildPaymentHeader(title: "Payment details",
                                                 subtitle: "Accepting your favourite payment methods"),
            addBillingButton: theme.buildAddBillingSectionButton(text: "Add billing details",
                                                                 isBillingAddressMandatory: false,
                                                                 titleText: "Billing details"),
            billingSummary: billingSummary,
            cardholder: theme.buildPaymentInput(isTextFieldNumericInput: false,
                                                titleText: "Cardholder"),
            cardNumber: theme.buildPaymentInput(isTextFieldNumericInput: true,
                                                titleText: "Card number",
                                                errorText: "Please enter valid card number",
                                                errorImage: UIImage(named: "warning")),
            expiryDate: theme.buildPaymentInput(textFieldPlaceholder: "__ / __",
                                                isTextFieldNumericInput: true,
                                                titleText: "Expiry date",
                                                errorText: "Please enter valid expiry date",
                                                errorImage: UIImage(named: "warning")),
            securityCode: theme.buildPaymentInput(isTextFieldNumericInput: true,
                                                  titleText: "Security number",
                                                  subtitleText: "Usually 3-4 digits on the back of the card",
                                                  errorText: "Please enter valid security number",
                                                  errorImage: UIImage(named: "warning")),
            payButton: payButton)

        let billingFormStyle = theme.buildBillingForm(
            header: theme.buildBillingHeader(title: "Billing Details",
                                             cancelButtonTitle: "Cancel",
                                             doneButtonTitle: "Done"),
            cells: [
                .fullName(theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: false, title: "Cardholder name")),
                .addressLine1(theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "Address line 1", isRequiredText: "°")),
                .addressLine2(theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: false, title: "Address line 2")),
                .city(theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "City", isRequiredText: "°")),
                .postcode(theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: false, title: "Postcode")),
                .country(theme.buildBillingCountryInput(buttonText: "Select country", title: "Country", isRequiredText: "°")),
                .phoneNumber(theme.buildBillingInput(text: "", isNumericInput: true, isMandatory: false, title: "Phone number"))
            ])

        return PaymentStyle(paymentFormStyle: paymentFormStyle,
                            billingFormStyle: billingFormStyle)
    }

}
#endif
