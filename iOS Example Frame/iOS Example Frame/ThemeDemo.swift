//
//  ThemeDemo.swift
//  iOS Example Frame
//
//  Created by Alex Ioja-Yang on 18/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit
import Frames

// swiftlint:disable function_body_length
enum ThemeDemo {

    static func buildCustom2Example() -> PaymentStyle {
        var theme = Theme(primaryFontColor: UIColor(red: 0 / 255, green: 204 / 255, blue: 45 / 255, alpha: 1),
                          secondaryFontColor: UIColor(red: 177 / 255, green: 177 / 255, blue: 177 / 255, alpha: 1),
                          buttonFontColor: .green,
                          errorFontColor: .red,
                          backgroundColor: UIColor(red: 23 / 255, green: 32 / 255, blue: 30 / 255, alpha: 1),
                          errorBorderColor: .red)
        theme.textInputBackgroundColor = UIColor(red: 36 / 255.0, green: 48 / 255.0, blue: 45 / 255.0, alpha: 1.0)
        theme.textInputBorderRadius = 4
        theme.borderRadius = 4

        var billingSummary = theme.buildBillingSummary(buttonText: "Change billing details",
                                                       titleText: "Billing details")
        billingSummary.borderStyle.normalColor = .white
        billingSummary.borderStyle.borderWidth = 1

        var cardholderInput = theme.buildPaymentInput(isTextFieldNumericInput: false,
                                                      titleText: "Cardholder name",
                                                      isRequiredInputText: "Optional")
        cardholderInput.isMandatory = false

        var payButton = theme.buildPayButton(text: "Pay now")
        payButton.textAlignment = .center

        let paymentFormStyle = theme.buildPaymentForm(
            headerView: theme.buildPaymentHeader(title: "Payment details",
                                                 subtitle: "Accepting your favourite payment methods"),
            addBillingButton: theme.buildAddBillingSectionButton(text: "Add billing details",
                                                                 isBillingAddressMandatory: false,
                                                                 titleText: "Billing details"),
            billingSummary: billingSummary,
            cardholder: cardholderInput,
            cardNumber: theme.buildPaymentInput(isTextFieldNumericInput: true,
                                                titleText: "Card number",
                                                errorText: "Please enter valid card number",
                                                errorImage: UIImage(named: "warning")),
            expiryDate: theme.buildPaymentInput(textFieldPlaceholder: "__ / __",
                                                isTextFieldNumericInput: false,
                                                titleText: "Expiry date",
                                                errorText: "Please enter valid expiry date",
                                                errorImage: UIImage(named: "warning")),
            securityCode: theme.buildPaymentInput(isTextFieldNumericInput: true,
                                                  titleText: "CVV date",
                                                  errorText: "Please enter valid security code",
                                                  errorImage: UIImage(named: "warning")),
            payButton: payButton)

        let billingFormStyle = theme.buildBillingForm(
            header: theme.buildBillingHeader(title: "Billing information",
                                             cancelButtonTitle: "Cancel",
                                             doneButtonTitle: "Done"),
            cells: [.fullName(theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: false, title: "Your name")),
                    .addressLine1(theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "Address")),
                    .city(theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "City")),
                    .country(theme.buildBillingCountryInput(buttonText: "Select your country", title: "Country")),
                    .phoneNumber(theme.buildBillingInput(text: "", isNumericInput: true, isMandatory: true, title: "Phone number"))])

        return PaymentStyle(paymentFormStyle: paymentFormStyle,
                            billingFormStyle: billingFormStyle)
    }

}
