//
//  OtherStyle.swift
//  iOS Example Frame
//
//  Created by Alex Ioja-Yang on 18/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//
import UIKit
import Frames

enum OtherStyle {

    // MARK: Matrix Style with one function
    static func buildWithOneFunction() -> FramesStyle {
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
        billingSummary.borderColor = .white
        billingSummary.borderWidth = 1

        var cardholderInput = theme.buildPaymentInput(isTextFieldNumericInput: false,
                                                      titleText: "Cardholder name",
                                                      isRequiredInputText: "Optional")
        cardholderInput.isMandatory = false

        var payButton = theme.buildPayButton(text: "Pay now!")
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
            cells: [.fullName(theme.buildBillingInput(text: "", isNumbericInput: false, isMandatory: false, title: "Your name")),
                    .addressLine1(theme.buildBillingInput(text: "", isNumbericInput: false, isMandatory: true, title: "Address")),
                    .city(theme.buildBillingInput(text: "", isNumbericInput: false, isMandatory: true, title: "City")),
                    .country(theme.buildBillingCountryInput(buttonText: "Select your country", title: "Country")),
                    .phoneNumber(theme.buildBillingInput(text: "", isNumbericInput: true, isMandatory: true, title: "Phone number"))])

        return FramesStyle(paymentFormStyle: paymentFormStyle,
                            billingFormStyle: billingFormStyle)
    }

}

// MARK: Matrix Style With Separated Styles
extension OtherStyle {
    /// This is the separated implementation for Matrix style
    static func buildWithSeparatedStyles() -> FramesStyle {
        let theme = getColorTheme()
        let paymentFormTheme = getPaymentFormTheme(with: theme)
        let billingFormTheme = getBillingFormTheme(with: theme)

        return FramesStyle(paymentFormStyle: paymentFormTheme,
                           billingFormStyle: billingFormTheme)
    }

}

// MARK: Color Theme
extension OtherStyle {

    private static func getColorTheme() -> Theme {
        var theme = Theme(primaryFontColor: UIColor(red: 0 / 255, green: 204 / 255, blue: 45 / 255, alpha: 1),
                          secondaryFontColor: UIColor(red: 177 / 255, green: 177 / 255, blue: 177 / 255, alpha: 1),
                          buttonFontColor: .green,
                          errorFontColor: .red,
                          backgroundColor: UIColor(red: 23 / 255, green: 32 / 255, blue: 30 / 255, alpha: 1),
                          errorBorderColor: .red)
        theme.textInputBackgroundColor = UIColor(red: 36 / 255.0, green: 48 / 255.0, blue: 45 / 255.0, alpha: 1.0)
        theme.textInputBorderRadius = 4
        theme.borderRadius = 4
        return theme
    }
}

// MARK: Frames Theme
extension OtherStyle {

    // MARK: - Payment Form Theme
    private static func getPaymentFormTheme(with theme: Theme) -> Theme.ThemePaymentForm {
        let headerView = getPaymentHeaderViewTheme(with: theme)
        let cardholderInput = getCardholderInputTheme(with: theme)
        let cardNumber = getCardNumberInputTheme(with: theme)
        let expiryDate = getExpiryDateInputTheme(with: theme)
        let securityCode = getSecurityCodeTheme(with: theme)
        let addBillingButton = getAddBillingButtonTheme(with: theme)
        let billingSummary = getBillingSummaryTheme(with: theme)
        let payButton = getPayButtonTheme(with: theme)

        return theme.buildPaymentForm(
            headerView: headerView,
            addBillingButton: addBillingButton,
            billingSummary: billingSummary,
            cardholder: cardholderInput,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            securityCode: securityCode,
            payButton: payButton)
    }

    // MARK: - Billing Form Theme
    private static func getBillingFormTheme(with theme: Theme) -> Theme.ThemeBillingForm {
        let headerView = getBillingFormHeaderViewTheme(with: theme)
        let cells = getBillingFormCellsTheme(with: theme)

        return theme.buildBillingForm(
            header: headerView,
            cells: cells)
    }
}

// MARK: - Payment form Theme
extension OtherStyle {

    // MARK: - Payment Header view
    private static func getPaymentHeaderViewTheme(with theme: Theme) -> Theme.ThemePaymentHeader {
        theme.buildPaymentHeader(title: "Payment details",
                                 subtitle: "Accepting your favourite payment methods")
    }

    // MARK: - Card Holder
    private static func getCardholderInputTheme(with theme: Theme) -> Theme.ThemePaymentInput {
        var cardholderInput = theme.buildPaymentInput(isTextFieldNumericInput: false,
                                                      titleText: "Cardholder name",
                                                      isRequiredInputText: "Optional")
        cardholderInput.isMandatory = false
        return cardholderInput
    }

    // MARK: - Card Number
    private static func getCardNumberInputTheme(with theme: Theme) -> Theme.ThemePaymentInput {
        theme.buildPaymentInput(isTextFieldNumericInput: true,
                                titleText: "Card number",
                                errorText: "Please enter valid card number",
                                errorImage: UIImage(named: "warning"))
    }

    // MARK: - Expiry Date
    private static func getExpiryDateInputTheme(with theme: Theme) -> Theme.ThemePaymentInput {
        theme.buildPaymentInput(textFieldPlaceholder: "__ / __",
                                isTextFieldNumericInput: false,
                                titleText: "Expiry date",
                                errorText: "Please enter valid expiry date",
                                errorImage: UIImage(named: "warning"))
    }

    // MARK: - Security Code
    private static func getSecurityCodeTheme(with theme: Theme) -> Theme.ThemePaymentInput {
        theme.buildPaymentInput(isTextFieldNumericInput: true,
                                titleText: "CVV date",
                                errorText: "Please enter valid security code",
                                errorImage: UIImage(named: "warning"))
    }

    // MARK: - Add Billing Button
    private static func getAddBillingButtonTheme(with theme: Theme) -> Theme.ThemeAddBillingSectionButton {
        theme.buildAddBillingSectionButton(text: "Add billing details",
                                           isBillingAddressMandatory: false,
                                           titleText: "Billing details")
    }

    // MARK: - Billing Summary
    private static func getBillingSummaryTheme(with theme: Theme) -> Theme.ThemeBillingSummary {
        var billingSummary = theme.buildBillingSummary(buttonText: "Change billing details",
                                                       titleText: "Billing details")
        billingSummary.borderColor = .white
        billingSummary.borderWidth = 1
        return billingSummary
    }

    // MARK: - Pay Button
    private static func getPayButtonTheme(with theme: Theme) -> Theme.ThemePayButton {
        var payButton = theme.buildPayButton(text: "Pay now!")
        payButton.textAlignment = .center
        return payButton
    }

}

// MARK: Billing form Theme
extension OtherStyle {

    // MARK: - Billing Form cells
    private static func getBillingFormCellsTheme(with theme: Theme) -> [BillingFormCell] {
        let fullName = getBillingFormFullNameTheme(with: theme)
        let addressLine1 = getAddressLine1Theme(with: theme)
        let city = getCityTheme(with: theme)
        let country = getCountryTheme(with: theme)
        let phoneNumber = getPhoneNumberTheme(with: theme)

        return  [.fullName(fullName),
                 .addressLine1(addressLine1),
                 .city(city),
                 .country(country),
                 .phoneNumber(phoneNumber)]
    }

    // MARK: - Billing Form Header View
    private static func getBillingFormHeaderViewTheme(with theme: Theme) -> Theme.ThemeBillingHeader {
        theme.buildBillingHeader(title: "Billing information",
                                 cancelButtonTitle: "Cancel",
                                 doneButtonTitle: "Done")
    }

    // MARK: - billing form full name
    private static func getBillingFormFullNameTheme(with theme: Theme) -> Theme.ThemeBillingInput {
        theme.buildBillingInput(text: "",
                                isNumbericInput: false,
                                isMandatory: false,
                                title: "Your name")
    }

    // MARK: - Address line 1
    private static func getAddressLine1Theme(with theme: Theme) -> Theme.ThemeBillingInput {
        theme.buildBillingInput(text: "",
                                isNumbericInput: false,
                                isMandatory: true,
                                title: "Address")
    }

    // MARK: - City
    private static func getCityTheme(with theme: Theme) -> Theme.ThemeBillingInput {
        theme.buildBillingInput(text: "",
                                isNumbericInput: false,
                                isMandatory: true,
                                title: "City")
    }

    // MARK: - Country
    private static func getCountryTheme(with theme: Theme) -> Theme.ThemeBillingCountryInput {
        theme.buildBillingCountryInput(buttonText: "Select your country",
                                       title: "Country")
    }

    // MARK: - Phone Number
    private static func getPhoneNumberTheme(with theme: Theme) -> Theme.ThemeBillingInput {
        theme.buildBillingInput(text: "",
                                isNumbericInput: true,
                                isMandatory: true,
                                title: "Phone number")
    }
}
